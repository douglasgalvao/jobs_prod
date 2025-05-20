import 'package:flutter/material.dart';
import 'package:my_jobs/infrastructure/providers/auth_provider.dart';
import 'package:my_jobs/infrastructure/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logout {

  static Future<void> call(WidgetRef ref) async {
    try {
      await ref.read(userProvider.notifier).clearUser();
      final authService = ref.read(authProvider);
      await authService.signOut();
      if (ref.context.mounted) {
        Navigator.pushReplacementNamed(ref.context, '/login');
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Erro ao sair: ${e.toString()}')),
        );
      }
    }
  }

}