import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/components/auth_state.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends AuthState<LoginPage> {
  final bool _isLoading = false;
  late final TextEditingController _emailController;

  Future<void> _signIn() async {
    await supabase.auth.signInWithProvider(Provider.google,
        options: AuthOptions(
            redirectTo: 'com.pomagacze.pomagacze://login-callback/'));
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zaloguj się')),
      body: Padding(padding: const EdgeInsets.only(bottom: 20), child: Align(
        alignment: Alignment.bottomCenter,
        child: !_isLoading ? const CircularProgressIndicator(color: Colors.white,) : GoogleAuthButton(
            style: const AuthButtonStyle(),
            onPressed: _signIn,
            themeMode: ThemeMode.light,
            text: 'Zaloguj się z Google'),
      )),
    );
  }
}
