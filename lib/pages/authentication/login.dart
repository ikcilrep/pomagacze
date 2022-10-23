import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomagacze/components/authentication/auth_state.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends AuthState<LoginPage> {
  final _isLoading = <Provider, bool>{
    Provider.google: false,
    Provider.facebook: false
  };
  late final TextEditingController _emailController;

  Provider? _lastProviderUsed;

  Future<void> _signIn(Provider provider) async {
    _lastProviderUsed = provider;
    await supabase.auth.signInWithProvider(provider,
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
  void onAuthenticated(Session session) async {
    setState(() {
      if (_lastProviderUsed != null) _isLoading[_lastProviderUsed!] = true;
    });

    super.onAuthenticated(session);
  }

  AuthButtonStyle get _authButtonStyle => AuthButtonStyle(
        textStyle: Theme.of(context).typography.englishLike.bodyText2,
        height: 50,
        borderRadius: 50,
        width: 100,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginBg.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 50, top: 100),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("POMAGACZE",
                      style: GoogleFonts.oswald(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headline2
                              ?.copyWith(color: Colors.black))),
                  Center(
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GoogleAuthButton(
                              style: _authButtonStyle,
                              isLoading: _isLoading[Provider.google] ?? false,
                              onPressed: () => _signIn(Provider.google),
                              themeMode: ThemeMode.light,
                              text: 'Zaloguj się z Google'),
                          const SizedBox(height: 10),
                          FacebookAuthButton(
                              style: _authButtonStyle,
                              isLoading: _isLoading[Provider.facebook] ?? false,
                              onPressed: () => _signIn(Provider.facebook),
                              themeMode: ThemeMode.light,
                              text: 'Zaloguj się z Facebook')
                        ],
                      ),
                    ),
                  )
                ])),
      ),
    );
  }
}
