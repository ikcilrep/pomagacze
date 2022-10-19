import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pomagacze/utils/constants.dart';

class NearbyOrganizersList extends StatefulWidget {
  const NearbyOrganizersList({super.key});

  @override
  State<StatefulWidget> createState() => NearbyOrganizersListState();
}

class NearbyOrganizersListState extends State<NearbyOrganizersList> {
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    startAdvertising();
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    super.dispose();
  }

  void startAdvertising() async {
    if (await Permission.bluetooth.request().isGranted &&
        await Permission.location.request().isGranted) {
      await Nearby().startAdvertising(
        supabase.auth.user()?.id ?? '',
        Strategy.P2P_CLUSTER,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          print(id);
        },
        onConnectionResult: (String id, Status status) {
          print(id);
        },
        onDisconnected: (String id) {
          // Callled whenever a discoverer disconnects from advertiser
        },
        serviceId: "com.pomagacze.pomagacze", // uniquely identifies your app
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Icon(Icons.visibility_outlined, size: 100),
      Text("Jesteś widoczny dla organizatora w pobliżu.",
          textAlign: TextAlign.center)
    ]);
  }
}
