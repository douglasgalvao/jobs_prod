
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_jobs/domain/services/auth_service.dart';
import 'package:my_jobs/infrastructure/firebase/firebase_auth_service.dart';

final authProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});