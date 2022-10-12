import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/pages/event_form.dart';
import 'package:pomagacze/state/events.dart';
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
  bool _isFABLoading = false;

  FutureProvider<HelpEvent> get eventProvider {
    return eventFutureProvider(widget.helpEvent.id!);
  }

  List<Volunteer> get eventVolunteers =>
      ref.read(eventProvider).valueOrNull?.volunteers ?? [];

  HelpEvent get event =>
      ref.read(eventProvider).valueOrNull ?? HelpEvent.empty();

  UserProfile? get userProfile => ref.read(userProfileProvider).valueOrNull;

  List<Volunteer>? get userEvents => ref.read(userEventsProvider).valueOrNull;

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(eventProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.helpEvent.title), actions: [
        Visibility(
          visible: data.hasValue &&
              data.value?.authorId == supabase.auth.currentUser?.id,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return EventForm(
                    initialData: HelpEvent.fromData(data.value?.toJson()));
              }));
            },
          ),
        )
      ]),
      floatingActionButton: Visibility(
          visible: data.hasValue &&
              userEvents != null &&
              userProfile != null &&
              canJoin(userProfile!, data.valueOrNull?.volunteers ?? []),
          child: _buildFAB()),
      body: data.when(
          data: (data) => buildSuccess(context, data),
          error: (err, stack) {
            print(err);
            print(stack);
            return const Center(child: Text('Coś poszło nie tak...'));
          },
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  Widget buildSuccess(BuildContext context, HelpEvent event) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy - kk:mm');

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
              title: const Text("Lokalizacja"),
              subtitle: Text(event.addressFull ?? '')),
          ListTile(
              title: const Text("Czas rozpoczęcia"),
              subtitle:
                  Text(dateFormat.format(event.dateStart ?? DateTime.now()))),
          ListTile(
              title: const Text("Czas zakończenia"),
              subtitle:
                  Text(dateFormat.format(event.dateEnd ?? DateTime.now()))),
          ListTile(
              title: const Text("Opis"), subtitle: Text(event.description)),
          ListTile(
              title: const Text("Wymagany wiek wolontariusza"),
              subtitle: Text(ageRangeString)),
          ListTile(
              title: const Text("Zgłoszeni wolontariusze"),
              subtitle: Text(numberOfVolunteersText())),
          Visibility(
              visible: userProfile != null &&
                  !canJoin(userProfile!, event.volunteers),
              child: const ListTile(
                  title: Text(
                      "Nie spełniasz wymagań potrzebnych, żeby dołączyć do tego wydarzenia."))),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
        onPressed: () async {
          if (_isFABLoading) return;

          setState(() {
            _isFABLoading = true;
          });
          await switchMembershipState(userEvents, userProfile!);

          await Future.wait(<Future>[
            ref.refresh(userEventsProvider.future),
            ref.refresh(feedFutureProvider.future),
            ref.refresh(eventProvider.future),
          ]);

          setState(() {
            _isFABLoading = false;
          });
        },
        label: Text(!hasJoinedTheEvent(userEvents) ? 'Dołącz' : "Opuść"),
        icon: (userProfile == null || _isFABLoading)
            ? Transform.scale(
                scale: 0.6,
                child: const CircularProgressIndicator(color: Colors.white))
            : Icon(
                !hasJoinedTheEvent(userEvents) ? Icons.check : Icons.logout));
  }

  String numberOfVolunteersText() {
    return "${eventVolunteers.length}/${event.maximalNumberOfVolunteers}";
  }

  Future<void> switchMembershipState(
      List<Volunteer>? userEvents, UserProfile userProfile) async {
    if (!hasJoinedTheEvent(userEvents)) {
      if (canJoin(userProfile, eventVolunteers)) {
        await joinEvent(userProfile);
      }
    } else {
      await VolunteersDB.deleteByUserId(userEvents![0].userId);
    }
    ref.invalidate(feedFutureProvider);
  }

  String get ageRangeString {
    if (event.minimalAge == null && event.maximalAge == null) {
      return "Brak";
    }

    if (event.minimalAge == null) {
      return 'Maksymalnie ${event.maximalAge} lat';
    }

    if (event.maximalAge == null) {
      return 'Przynajmniej ${event.minimalAge} lat';
    }

    return '${event.minimalAge} - ${event.maximalAge} lat';
  }

  bool canJoin(UserProfile userProfile, List<Volunteer> eventVolunteers) {
    return (event.maximalNumberOfVolunteers == null ||
            eventVolunteers.length < event.maximalNumberOfVolunteers!) &&
        isYoungEnough(userProfile) &&
        isOldEnough(userProfile);
  }

  bool isOldEnough(UserProfile userProfile) =>
      event.minimalAge == null || event.minimalAge! <= userProfile.age;

  bool isYoungEnough(UserProfile userProfile) =>
      event.maximalAge == null || event.maximalAge! >= userProfile.age;

  Future<void> joinEvent(UserProfile userProfile) async {
    final volunteer = Volunteer(
        userId: supabase.auth.user()!.id, eventId: widget.helpEvent.id!);
    await VolunteersDB.upsert(volunteer);
  }

  bool hasJoinedTheEvent(List<Volunteer>? userEvents) {
    return userEvents != null &&
        userEvents.any((volunteer) => volunteer.eventId == widget.helpEvent.id);
  }
}
