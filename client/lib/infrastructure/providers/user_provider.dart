import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_jobs/domain/entitites/user_model.dart';
import '../../presentation/providers/user_notifier.dart';

final secureStorageProvider = Provider((_) => const FlutterSecureStorage());

final userProvider =
  StateNotifierProvider<UserNotifier, UserData?>((ref) {
    return UserNotifier( ref.watch(secureStorageProvider) );
});