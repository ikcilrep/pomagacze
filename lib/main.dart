import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:pomagacze/pages/request_form.dart';
import 'package:pomagacze/pages/login.dart';
import 'package:pomagacze/pages/splash.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:pomagacze/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pomagacze/layouts/home.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: supabaseURL,
    anonKey: supabaseAnonKey,
  );

  initializeDateFormatting('pl');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (lightScheme, darkScheme) => MaterialApp(
              title: 'Pomagacze',
              theme: getTheme(),
              // darkTheme: getTheme(dark: true),
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                '/': (_) => const SplashPage(),
                '/login': (_) => const LoginPage(),
                '/home': (_) => const HomeLayout(),
                '/new': (_) => RequestForm(),
              },
            ));
  }
}
