import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:pomagacze/components/error_with_action.dart';
import 'package:pomagacze/state/permissions.dart';

class AskForPermissionsButton extends ConsumerWidget {
  const AskForPermissionsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothPermission = ref.watch(bluetoothPermissionProvider);
    final locationPermission = ref.watch(locationPermissionProvider);

    return ErrorWithAction(
      action: () async {
        await _askForLackingPermissions(
            locationPermission, bluetoothPermission);
        ref.refresh(bluetoothPermissionProvider);
        ref.refresh(locationPermissionProvider);
        await Future.delayed(const Duration(seconds: 2));
        ref.refresh(bluetoothPermissionProvider);
        ref.refresh(locationPermissionProvider);
      },

      actionText: 'Przyznaj uprawnienia',
      errorText: 'Ta funkcja wymaga dodatkowych uprawnień',
    );
  }

  Future<void> _askForLackingPermissions(AsyncValue<bool> locationPermission,
      AsyncValue<bool> bluetoothPermission) async {
    if (locationPermission.valueOrNull != true) {
      await Nearby().askLocationPermission();
    }

    if (bluetoothPermission.valueOrNull != true) {
      Nearby().askBluetoothPermission();
    }
  }
}
