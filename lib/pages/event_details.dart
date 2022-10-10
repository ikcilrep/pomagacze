import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/state/user.dart';

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

  bool canJoin(UserProfile userProfile) {
    return widget.helpEvent.minimalNumberOfVolunteers! <
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

  void joinEvent(UserProfile userProfile) {}

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy - kk:mm');
    return Scaffold(
      appBar: AppBar(title: Text(widget.helpEvent.title)),
      floatingActionButton: Visibility(
          visible: userProfile.hasValue && canJoin(userProfile.value!),
          child: FloatingActionButton.extended(
              onPressed: () {
                joinEvent(userProfile.value!);
              },
              label: const Text('Dołącz'),
              icon: !userProfile.hasValue
                  ? Transform.scale(
                      scale: 0.6,
                      child:
                          const CircularProgressIndicator(color: Colors.white))
                  : const Icon(Icons.check))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
                title: const Text("Miejsce zbiórki"),
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
          ],
        ),
      ),
    );
  }
}
