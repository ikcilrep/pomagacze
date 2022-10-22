import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final locationPermissionProvider = FutureProvider((ref) async {
  return await Permission.location.isGranted;
});

final bluetoothPermissionProvider = FutureProvider((ref) async {
  return await Permission.bluetooth.isGranted;
});
