import 'package:flutter/material.dart';
import 'package:pomagacze/db/users.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void onAuthenticated(Session session) async {
    if (!await UsersDB.profileExists(session.user?.id ?? '') && mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/setup-profile', (route) => false);
    } else if (mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/onboarding', (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
