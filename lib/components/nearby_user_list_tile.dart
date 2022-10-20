import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/user_avatar.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/utils/snackbar.dart';

class NearbyVolunteerListTile extends ConsumerStatefulWidget {
  final Volunteer volunteer;

  const NearbyVolunteerListTile({Key? key, required this.volunteer})
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
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(
            message: 'Nie udało się potwierdzić uczestnictwa wolontariusza.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
