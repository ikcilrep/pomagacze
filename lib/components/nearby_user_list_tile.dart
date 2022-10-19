import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/user_avatar.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/state/events.dart';

class NearbyVolunteerListTile extends ConsumerWidget {
  final Volunteer volunteer;

  const NearbyVolunteerListTile({Key? key, required this.volunteer})
      : super(key: key);

  AutoDisposeFutureProvider<HelpEvent> get eventProvider {
    return eventFutureProvider(volunteer.eventId);
  }

  Future<void> _confirmVolunteerParticipation(WidgetRef ref) async {
    volunteer.isParticipationConfirmed = true;
    await VolunteersDB.update(volunteer);
    ref.refresh(eventProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        title: Text(volunteer.profile!.name ?? ''),
        leading: UserAvatar(volunteer.profile!),
        trailing: IconButton(
            icon: const Icon(Icons.done, color: Colors.teal),
            onPressed: () => _confirmVolunteerParticipation(ref)),
      ),
    );
  }
}
