import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/components/auth_state.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
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
  void onAuthenticated(Session session) async {
    setState(() {
      _isLoading = true;
    });

    super.onAuthenticated(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
          title: const Center(
              child: Text('Pomagacze',
                  style: TextStyle(fontWeight: FontWeight.bold)))),*/
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginBGgren.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 50, top: 100),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("POMAGACZE", style: GoogleFonts.oswald(textStyle: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.black) )),
                  Center(
                    child: GoogleAuthButton(
                        style: AuthButtonStyle(
                          textStyle: Theme.of(context)
                              .typography
                              .englishLike
                              .bodyText2,
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
