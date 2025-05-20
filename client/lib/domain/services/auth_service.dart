import '../entitites/user_model.dart';


abstract class AuthService {
  UserData? get currentUser;
  Stream<UserData?> authStateChanges();
  Future<UserData?> signInWithEmailAndPassword(String email, String password);
  Future<UserData?> signInWithGoogle();
  // Future<UserData?> signInWithGithub();
  Future<void> signOut();
}




