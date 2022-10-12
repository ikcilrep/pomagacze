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
      appBar: AppBar(
          title: const Center(
              child: Text('Pomagacze',
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/shakeIcon.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: GoogleAuthButton(
                        style: AuthButtonStyle(
                          textStyle: Theme.of(context).typography.englishLike.bodyText2,
                          height: 50,
                        ),
                        isLoading: _isLoading,
                        onPressed: _signIn,
                        themeMode: ThemeMode.light,
                        text: 'Zaloguj się z Google'),
                  )
                ])),
      ),
    );
  }
}
