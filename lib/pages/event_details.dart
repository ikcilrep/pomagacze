import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/state/feed.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/state/volunteers.dart';
import 'package:pomagacze/utils/constants.dart';

class EventDetails extends ConsumerStatefulWidget {
  final HelpEvent helpEvent;

  const EventDetails(this.helpEvent, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EventDetailsState();
}

class EventDetailsState extends ConsumerState<EventDetails> {
  String get ageRangeString {
    if (widget.helpEvent.minimalAge == null &&
        widget.helpEvent.maximalAge == null) {
      return "Brak";
    }

    if (widget.helpEvent.minimalAge == null) {
      return 'Maksymalnie ${widget.helpEvent.maximalAge} lat';
    }

    if (widget.helpEvent.maximalAge == null) {
      return 'Przynajmniej ${widget.helpEvent.minimalAge} lat';
    }

    return '${widget.helpEvent.minimalAge} - ${widget.helpEvent.maximalAge} lat';
  }

  bool canJoin(UserProfile userProfile, List<Volunteer> eventVolunteers) {
    return eventVolunteers.length <
            widget.helpEvent.maximalNumberOfVolunteers! &&
        isYoungEnough(userProfile) &&
        isOldEnough(userProfile);
  }

  bool isOldEnough(UserProfile userProfile) =>
      widget.helpEvent.minimalAge == null ||
      widget.helpEvent.minimalAge! <= userProfile.age;

  bool isYoungEnough(UserProfile userProfile) =>
      widget.helpEvent.maximalAge == null ||
      widget.helpEvent.maximalAge! >= userProfile.age;

  Future<void> joinEvent(UserProfile userProfile) async {
    final volunteer = Volunteer(
        userId: supabase.auth.user()!.id, eventId: widget.helpEvent.id!);
    await VolunteersDB.upsert(volunteer);
  }

  bool hasJoinedTheEvent(List<Volunteer>? userEvents) {
    return userEvents != null &&
        userEvents.any((volunteer) => volunteer.eventId == widget.helpEvent.id);
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final userEvents = ref.watch(userEventsProvider);
    final eventVolunteers =
        ref.watch(eventVolunteersProvider(widget.helpEvent.id!));
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy - kk:mm');

    return Scaffold(
      appBar: AppBar(title: Text(widget.helpEvent.title)),
      floatingActionButton: Visibility(
          visible: userEvents.hasValue &&
              userProfile.hasValue &&
              eventVolunteers.hasValue &&
              canJoin(userProfile.value!, eventVolunteers.value!),
          child: FloatingActionButton.extended(
              onPressed: () async {
                await switchMembershipState(userEvents.value,
                    eventVolunteers.value!, userProfile.value!);
                ref.refresh(userEventsProvider);
                ref.refresh(eventVolunteersProvider(widget.helpEvent.id!));
              },
              label: Text(
                  !hasJoinedTheEvent(userEvents.value) ? 'Dołącz' : "Opuść"),
              icon: !userProfile.hasValue
                  ? Transform.scale(
                      scale: 0.6,
                      child:
                          const CircularProgressIndicator(color: Colors.white))
                  : Icon(!hasJoinedTheEvent(userEvents.value)
                      ? Icons.check
                      : Icons.logout))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
                title: const Text("Lokalizacja"),
                subtitle: Text(widget.helpEvent.placeName ?? '')),
            ListTile(
                title: const Text("Czas rozpoczęcia"),
                subtitle: Text(dateFormat
                    .format(widget.helpEvent.dateStart ?? DateTime.now()))),
            ListTile(
                title: const Text("Czas zakończenia"),
                subtitle: Text(dateFormat
                    .format(widget.helpEvent.dateEnd ?? DateTime.now()))),
            ListTile(
                title: const Text("Opis"),
                subtitle: Text(widget.helpEvent.description)),
            ListTile(
                title: const Text("Wymagany wiek wolontariusza"),
                subtitle: Text(ageRangeString)),
            Visibility(
                visible: eventVolunteers.hasValue,
                child: ListTile(
                    title: const Text("Zgłoszeni wolontariusze"),
                    subtitle: Text(numberOfVolunteersText(eventVolunteers)))),
            Visibility(
                visible: userProfile.hasValue &&
                    eventVolunteers.hasValue &&
                    !canJoin(userProfile.value!, eventVolunteers.value!),
                child: const ListTile(
                    title: Text(
                        "Nie spełniasz wymagań potrzebnych, żeby dołączyć do tego wydarzenia."))),
          ],
        ),
      ),
    );
  }

  String numberOfVolunteersText(AsyncValue<List<Volunteer>> eventVolunteers) =>
      "${!eventVolunteers.hasValue ? 0 : eventVolunteers.value!.length}/${widget.helpEvent.maximalNumberOfVolunteers}";

  Future<void> switchMembershipState(List<Volunteer>? userEvents,
      List<Volunteer> eventVolunteers, UserProfile userProfile) async {
    if (!hasJoinedTheEvent(userEvents)) {
      if (canJoin(userProfile, eventVolunteers)) {
        await joinEvent(userProfile);
      }
    } else {
      await VolunteersDB.deleteByUserId(userEvents![0].userId);
    }
    ref.invalidate(feedFutureProvider);
  }
}
