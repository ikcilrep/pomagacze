import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:pomagacze/components/congratulations_dialog.dart';
import 'package:pomagacze/components/participation_confirmed_message.dart';
import 'package:pomagacze/components/visible_for_organizer_message.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/state/users.dart';
import 'package:pomagacze/utils/constants.dart';

class NearbyOrganizersList extends ConsumerStatefulWidget {
  final HelpEvent event;

  const NearbyOrganizersList({super.key, required this.event});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NearbyOrganizersListState();
}

class NearbyOrganizersListState extends ConsumerState<NearbyOrganizersList> {
  bool isInit = false;

  AutoDisposeFutureProvider<HelpEvent> get eventProvider =>
      eventFutureProvider(widget.event.id!);

  @override
  void initState() {
    super.initState();
    startAdvertising();
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    Nearby().stopAllEndpoints();
    super.dispose();
  }

  void refreshIfAcceptedByOrganizer(String endpointId, Payload payload) {
    if (payload.type == PayloadType.BYTES) {
      final String message = utf8.decode(payload.bytes!);
      if (message == widget.event.id) {
        ref.refresh(eventProvider);
        ref.refresh(currentUserProvider);
        _showCongratulationsDialog();
      }
    }
  }

  void onDismiss() {
    Navigator.of(context).pop();
  }

  void _showCongratulationsDialog() {
    if (mounted) {
      showDialog(
          context: context,
          builder: (_) => CongratulationsDialog(
              event: widget.event,
              onDismiss: () => Navigator.of(context).pop()));
    }
  }

  void acceptIfFromOrganizer(String id, ConnectionInfo info) {
    if (info.endpointName == widget.event.authorId) {
      Nearby().acceptConnection(id,
          onPayLoadRecieved: refreshIfAcceptedByOrganizer);
    } else {
      Nearby().rejectConnection(id);
    }
  }

  void startAdvertising() async {
    await Nearby().stopAdvertising();
    if (!await Nearby().checkLocationPermission()) {
      await Nearby().askLocationPermission();
    }
    if (!await Nearby().checkBluetoothPermission()) {
      Nearby().askBluetoothPermission();
    }

    await Nearby().startAdvertising(
      supabase.auth.user()?.id ?? '',
      Strategy.P2P_CLUSTER,
      onConnectionInitiated: acceptIfFromOrganizer,
      onConnectionResult: (String id, Status status) {},
      onDisconnected: (String id) {
        // Callled whenever a discoverer disconnects from advertiser
      },
      serviceId: "com.pomagacze.pomagacze", // uniquely identifies your app
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventProvider);
    return event.when(
        data: (event) {
          final volunteer = event.volunteers.firstWhere(
              (element) => element.userId == ref.read(currentUserIdProvider));
          return volunteer.isParticipationConfirmed
              ? const ParticipationConfirmedMessage()
              : const VisibleForOrganizerMessage();
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
