import 'package:flutter/material.dart';

/* PALETTE 1
252, 222, 190
0, 150, 136
4, 4, 22
71, 68, 74
 -- 179, 200, 184
160, 135, 148
 */
/* PALETTE 2
48, 186, 179 -- aqua -- 48, 186, 152 more green -- 46, 178, 145 darker
254, 245, 236 -- light yellow
16, 16, 73 dark blue -- 4, 4, 17 darker
148, 138, 163 -- gray violet -- 54, 34, 44 darker
172, 152, 164 -- gray red -- 171, 125, 149 more saturation

223, 247, 241 - light gray azure
*/

/*ColorScheme customLightScheme = const ColorScheme(brightness: Brightness.light,
    primary: Color.fromRGBO(46, 178, 145, 1),
    onPrimary: Color.fromRGBO(254, 245, 236, 1),
    secondary: Color.fromRGBO(16, 16, 73, 1),
    onSecondary: Color.fromRGBO(254, 245, 236 , 1),
    error: Color.fromRGBO(171, 125, 149, 1),
    onError: Color.fromRGBO(54, 34, 44, 1),
    background: Color.fromRGBO(148, 138, 163 , 1),
    onBackground: Color.fromRGBO(0, 150, 136, 1),
    surface: Color.fromRGBO(249, 255, 253, 1.0),
    onSurface: Color.fromRGBO(5, 5, 23, 1));*/

ColorScheme defaultLightScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.teal, accentColor: Colors.teal[200]).copyWith(primary: Colors.teal[500]);
ColorScheme defaultDarkScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.teal, brightness: Brightness.dark);

ThemeData getTheme({bool dark = false}) {
  late ThemeData data;
  if (dark) {
    data = ThemeData.dark(useMaterial3: true)
        .copyWith(colorScheme: defaultDarkScheme);
  } else {
    data = ThemeData.light(useMaterial3: true)
        .copyWith(colorScheme: defaultLightScheme);
  }
  return data.copyWith(
      inputDecorationTheme: const InputDecorationTheme(),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              side: BorderSide(
        width: 1,
        color: data.colorScheme.secondary,
        style: BorderStyle.solid,
      ))),
      listTileTheme: const ListTileThemeData(tileColor: Colors.transparent));
}
