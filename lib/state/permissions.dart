import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';

final locationPermissionProvider = FutureProvider((ref) async {
  return await Nearby().checkLocationPermission();
});

final bluetoothPermissionProvider = FutureProvider((ref) async {
  return await Nearby().checkBluetoothPermission();
});
