import 'package:flutter/material.dart';
import 'package:pomagacze/pages/account.dart';
import 'package:pomagacze/pages/login.dart';
import 'package:pomagacze/pages/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
    await Supabase.initialize(
      url: 'https://urvsgbuuxnpnefnxtoha.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVydnNnYnV1eG5wbmVmbnh0b2hhIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjUyMzgyMDcsImV4cCI6MTk4MDgxNDIwN30.5Dr6OU0WmAShKgZ8Awnllkc2NkcSvoSQdD3cf5BjUgA',
    );

    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomagacze',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
      },
    );
  }
}