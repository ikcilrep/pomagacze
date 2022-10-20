import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:pomagacze/components/nearby_user_list_tile.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/nearby_device.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/state/events.dart';

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

  bool isInit = false;

  @override
  void dispose() {
    Nearby().stopDiscovery();
    super.dispose();
  }

  @override
  void initState() {
    startDiscovery();
    super.initState();
  }

  Future<void> startDiscovery() async {
    await Nearby().stopDiscovery();
    if (!await Nearby().checkLocationPermission()) {
      await Nearby().askLocationPermission();
    }
    if (!await Nearby().checkBluetoothPermission()) {
      Nearby().askBluetoothPermission();
    }
    Nearby().startDiscovery(
      "organizer",
      Strategy.P2P_CLUSTER,
      onEndpointFound: (String endpointId, String userId, String serviceId) {
        ref.refresh(eventProvider);
        if (_isUserAnUnconfirmedVolunteer(userId)) {
          setState(() {
            nearbyDevices.add(NearbyDevice(
                endpointId: endpointId, userId: userId, serviceId: serviceId));
          });
        } else {
          print("Found but not valid!");
        }
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
    final unconfirmedVolunteersDevices = nearbyDevices
        .where((device) => _isUserAnUnconfirmedVolunteer(device.userId))
        .toList();
    print("rebuilding");
    return ListView.builder(
        itemCount: unconfirmedVolunteersDevices.length,
        itemBuilder: (context, index) {
          final volunteer = eventVolunteers.firstWhere((element) =>
              element.userId == unconfirmedVolunteersDevices[index].userId);
          print(volunteer.isParticipationConfirmed);

          return NearbyVolunteerListTile(
            volunteer: volunteer,
          );
        });
  }
}
