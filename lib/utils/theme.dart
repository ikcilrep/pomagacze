import 'package:flutter/material.dart';

ColorScheme defaultLightScheme = ColorScheme.fromSwatch(primarySwatch: Colors.teal);
ColorScheme defaultDarkScheme = ColorScheme.fromSwatch(primarySwatch: Colors.teal, brightness: Brightness.dark);

ThemeData getTheme({bool dark = false}) {
  late ThemeData data;
  if(dark) {
    data = ThemeData.dark(useMaterial3: true).copyWith(colorScheme: defaultDarkScheme);
  } else {
    data = ThemeData.light(useMaterial3: true).copyWith(colorScheme: defaultLightScheme);
  }
  return data.copyWith(
    inputDecorationTheme: InputDecorationTheme(filled: true)
  );
}