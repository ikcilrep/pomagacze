import 'package:flutter/material.dart';
import 'package:pomagacze/db/users.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final completedOnboarding = prefs.getBool(hasCompletedOnboardingKey);

    if (!await UsersDB.profileExists(session.user?.id ?? '') && mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/setup-profile', (route) => false);
    } else if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          completedOnboarding == true ? '/home' : '/onboarding',
          (route) => false);
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
