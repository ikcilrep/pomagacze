import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:pomagacze/components/profile/user_avatar.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/nearby_device.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/state/users.dart';
import 'package:pomagacze/utils/snackbar.dart';

class NearbyVolunteerListTile extends ConsumerStatefulWidget {
  final Volunteer volunteer;
  final NearbyDevice device;

  const NearbyVolunteerListTile(
      {Key? key, required this.volunteer, required this.device})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NearbyVolunteerListTileState();
}

class NearbyVolunteerListTileState
    extends ConsumerState<NearbyVolunteerListTile> {
  AutoDisposeFutureProvider<HelpEvent> get eventProvider {
    return eventFutureProvider(widget.volunteer.eventId);
  }

  Future<void> _confirmVolunteerParticipation(BuildContext context) async {
    try {
      widget.volunteer.isParticipationConfirmed = true;
      await VolunteersDB.update(widget.volunteer);
      ref.refresh(eventProvider);
      if (mounted) {
        context.showSnackBar(
            message: 'Udało się potwierdzić uczestnictwo wolontariusza!');
      }
      await _notifyUserAboutSuccess();
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(
            message: 'Nie udało się potwierdzić uczestnictwa wolontariusza.');
      }
    }
  }

  Future<void> _notifyUserAboutSuccess() async {
    await Nearby().requestConnection(
        ref.read(currentUserIdProvider), widget.device.endpointId,
        onConnectionInitiated: (endpointId, info) async {
      await Nearby().acceptConnection(endpointId,
          onPayLoadRecieved: (String endpointId, Payload payload) {});
    }, onConnectionResult: (endpointId, status) async {
      if (status == Status.CONNECTED) {
        final encodedEventId =
            Uint8List.fromList(utf8.encode(widget.volunteer.eventId));
        await Nearby()
            .sendBytesPayload(widget.device.endpointId, encodedEventId);
      }
    }, onDisconnected: (endpointId) {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        title: Text(widget.volunteer.profile!.name ?? ''),
        leading: UserAvatar(widget.volunteer.profile!),
        trailing: IconButton(
            icon: const Icon(Icons.done, color: Colors.teal),
            onPressed: () => _confirmVolunteerParticipation(context)),
      ),
    );
  }
}
