// lib/presentation/providers/user_notifier.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_jobs/domain/entitites/user_model.dart';


class UserNotifier extends StateNotifier<UserData?> {
  final FlutterSecureStorage _storage;
  static const _key = 'logged_user';

  UserNotifier( this._storage ) : super(null) {
    _loadStoredUser();
  }

  Future<void> _loadStoredUser() async {
    final json = await _storage.read(key: _key);
    if (json != null) {
      state = UserData.fromJson( jsonDecode(json) );
    }
  }

  Future<void> setUser(UserData user) async {
    state = user;
    await _storage.write(key: _key, value: jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    state = null;
    await _storage.delete(key: _key);
  }
}
