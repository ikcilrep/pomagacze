import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:open_location_picker/open_location_picker.dart';
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

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final Location location = Location();

  MyApp({super.key});

  Widget _buildRoutes() {
    return DynamicColorBuilder(
        builder: (lightScheme, darkScheme) => MaterialApp(
              title: 'Pomagacze',
              theme: getTheme(),
              // darkTheme: getTheme(dark: true),
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              routes: <String, WidgetBuilder>{
                '/': (_) => const SplashPage(),
                '/login': (_) => const LoginPage(),
                '/home': (_) => const HomeLayout(),
                '/new': (_) => const RequestForm(),
              },
            ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OpenMapSettings(
      onError: (context, error) {},
      getCurrentLocation: _getCurrentLocationUsingLocationPackage,
      reverseZoom: ReverseZoom.building,
      getLocationStream: () => location.onLocationChanged
          .map((event) => LatLng(event.latitude!, event.longitude!)),
      child: _buildRoutes(),
      searchHint: (context) => 'Wyszukaj...',
    );
  }

  Future<LatLng?> _getCurrentLocationUsingLocationPackage() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception("Service is not enabled");
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception("Permission not granted");
      }
    }
    var locationData = await location.getLocation();

    return LatLng(locationData.latitude!, locationData.longitude!);
  }
}
