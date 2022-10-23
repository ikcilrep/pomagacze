import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/nearby_device.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/state/permissions.dart';

import 'ask_for_permissions_button.dart';
import 'nearby_user_list_tile.dart';

class NearbyUsersList extends ConsumerStatefulWidget {
  final HelpEvent event;

  const NearbyUsersList({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NearbyUsersListState();
}

class NearbyUsersListState extends ConsumerState<NearbyUsersList> {
  final List<NearbyDevice> nearbyDevices = [];

  AutoDisposeFutureProvider<HelpEvent> get eventProvider {
    return eventFutureProvider(widget.event.id!);
  }

  List<Volunteer> get eventVolunteers =>
      ref.watch(eventProvider).valueOrNull?.volunteers ?? [];

  bool _isDiscovering = false;

  @override
  void dispose() {
    Nearby().stopDiscovery();
    super.dispose();
  }

  Future<void> startDiscovery() async {
    await Nearby().stopDiscovery();
    Nearby().startDiscovery(
      "organizer",
      Strategy.P2P_CLUSTER,
      onEndpointFound: (String endpointId, String userId, String serviceId) {
        ref.refresh(eventProvider);
        setState(() {
          nearbyDevices.add(NearbyDevice(
              endpointId: endpointId, userId: userId, serviceId: serviceId));
        });
      },
      onEndpointLost: (String? endpointId) {
        nearbyDevices
            .removeWhere((element) => element.endpointId == endpointId);
      },
      serviceId: "com.pomagacze.pomagacze",
    );
  }

  bool _isUserAnUnconfirmedVolunteer(String userId) {
    return eventVolunteers.any((element) => element.userId == userId) &&
        !eventVolunteers
            .firstWhere((element) => element.userId == userId)
            .isParticipationConfirmed;
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothPermission = ref.watch(bluetoothPermissionProvider);
    final locationPermission = ref.watch(locationPermissionProvider);

    _discoverIfPermissionsGranted(bluetoothPermission, locationPermission);

    if (bluetoothPermission.valueOrNull != true ||
        locationPermission.valueOrNull != true) {
      return const AskForPermissionsButton();
    }

    final unconfirmedVolunteersDevices = nearbyDevices
        .where((device) => _isUserAnUnconfirmedVolunteer(device.userId))
        .toList();

    if (unconfirmedVolunteersDevices.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Wyszukiwanie wolontariuszy w pobliżu...'),
          SizedBox(height: 15),
          CircularProgressIndicator(),
          SizedBox(height: 100),
        ],
      );
    }

    return ListView.builder(
        itemCount: unconfirmedVolunteersDevices.length,
        itemBuilder: (context, index) {
          final volunteer = eventVolunteers.firstWhere((element) =>
              element.userId == unconfirmedVolunteersDevices[index].userId);

          return NearbyVolunteerListTile(
            volunteer: volunteer,
            device: unconfirmedVolunteersDevices[index],
          );
        });
  }

  void _discoverIfPermissionsGranted(AsyncValue<bool> bluetoothPermission,
      AsyncValue<bool> locationPermission) {
    if (bluetoothPermission.valueOrNull == true &&
        locationPermission.valueOrNull == true) {
      if (!_isDiscovering) {
        startDiscovery();
        _isDiscovering = true;
      }
    } else {
      Nearby().stopDiscovery();
      _isDiscovering = false;
    }
  }
}
