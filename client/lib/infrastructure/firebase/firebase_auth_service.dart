import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entitites/user_model.dart';
import '../../domain/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({
    firebase_auth.FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  UserData? get currentUser {
    final user = _auth.currentUser;
    return user != null ? _convertFirebaseUser(user) : null;
  }

  @override
  Stream<UserData?> authStateChanges() {
    return _auth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? _convertFirebaseUser(firebaseUser) : null;
    });
  }

  @override
  Future<UserData?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null 
          ? _convertFirebaseUser(userCredential.user!) 
          : null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('Email Sign-In Error: ${e.message}');
      throw _handleFirebaseError(e); // Converte para mensagem amigável
    }
  }

  @override
  Future<UserData?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      return result.user != null ? _convertFirebaseUser(result.user!) : null;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow; // Permite tratamento no LoginScreen
    }
  }

  // @override
  // Future<UserData?> signInWithGithub() async {
  //   try {
  //     final user = await FirebaseAuthOAuth().openSignInFlow(
  //       "github.com",
  //       ["user:email"],
  //       {"locale": "pt"},
  //     );
  //     return user;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Método auxiliar para conversão
  UserData _convertFirebaseUser(firebase_auth.User firebaseUser) {
    return UserData(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }

  // Tratamento de erros do Firebase
  String _handleFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuário desativado';
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'email-already-in-use':
        return 'Email já está em uso';
      case 'operation-not-allowed':
        return 'Operação não permitida';
      case 'weak-password':
        return 'Senha muito fraca';
      default:
        return 'Erro de autenticação: ${e.message}';
    }
  }
}