import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mailto/mailto.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/pages/event_form.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/state/user.dart';
import 'package:pomagacze/state/volunteers.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/gain_points_badge.dart';

class EventDetails extends ConsumerStatefulWidget {
  final HelpEvent helpEvent;

  const EventDetails(this.helpEvent, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EventDetailsState();
}

class EventDetailsState extends ConsumerState<EventDetails> {
  bool _isFABLoading = false;

  final _scrollController = ScrollController();
  double _imageOffset = 0;

  AutoDisposeFutureProvider<HelpEvent> get eventProvider {
    return eventFutureProvider(widget.helpEvent.id!);
  }

  List<Volunteer> get eventVolunteers =>
      ref.read(eventProvider).valueOrNull?.volunteers ?? [];

  HelpEvent? get event => ref.read(eventProvider).valueOrNull;

  UserProfile? get userProfile => ref.read(userProfileProvider).valueOrNull;

  List<Volunteer>? get userEvents => ref.read(userEventsProvider).valueOrNull;

  final _dateFormat = DateFormat('dd MMM yy HH:mm');

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _imageOffset = _scrollController.offset * 0.6;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(eventProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Wydarzenie"), actions: [
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
          data: (data) =>
              Builder(builder: (context) => buildSuccess(context, data)),
          error: (err, stack) {
            print(err);
            print(stack);
            return const Center(child: Text('Coś poszło nie tak...'));
          },
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  Widget buildSuccess(BuildContext context, HelpEvent event) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.imageUrl != null)
            Transform.translate(
              offset: Offset(0, _imageOffset),
              child: Stack(children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: Image.network(
                            event.imageUrl!,
                            fit: BoxFit.fitWidth,
                          ))),
                ),
                Positioned(right: 10, top: 10, child: PointsBadge(event: event))
              ]),
            ),
          /*ListTile(
              title: const Text("Lokalizacja"),
              subtitle: Text(event.addressFull ?? ''),
              trailing: const Icon(Icons.open_in_new),
              onTap: () async {
                showModalBottomSheet(
                    shape: bottomSheetShape,
                    context: context,
                    builder: (context) => ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: [
                            ListTile(
                                leading: const Icon(Icons.copy),
                                title: const Text('Skopiuj do schowka'),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  await Clipboard.setData(ClipboardData(
                                      text: event.addressFull ?? ''));
                                  Fluttertoast.showToast(
                                      msg: 'Skopiowano do schowka!');
                                }),
                            ListTile(
                                leading: const Icon(Icons.open_in_new),
                                title: const Text('Otwórz w mapach'),
                                onTap: () async {
                                  Navigator.of(context).pop();
                                  MapsLauncher.launchCoordinates(
                                      event.latitude!,
                                      event.longitude!,
                                      '${event.addressShort} - ${event.title}');
                                })
                          ],
                        ));
              }),*/
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 120),
            child: Container(
                transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.surface),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(event.title,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            fontWeight: FontWeight.w400)),
                              ),
                              if (event.imageUrl == null)
                                PointsBadge(event: event)
                            ],
                          )),
                      Visibility(
                        visible: userProfile != null &&
                            !canJoin(userProfile!, event.volunteers),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                          child: Text(
                            "Nie spełniasz wymagań, aby dołączyć".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            width: 16,
                          ),
                          Icon(Icons.event,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(
                            width: 10,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.black.withOpacity(0.05),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      //Text("OD", style: Theme.of(context).textTheme.overline),
                                      Text(
                                          _dateFormat.format(event.dateStart!)),
                                    ],
                                  ),
                                ),
                              )),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.black.withOpacity(0.05),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      //Text("DO", style: Theme.of(context).textTheme.overline),
                                      Text(_dateFormat.format(event.dateEnd!)),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                          title: const Text("Opis"),
                          subtitle: Text(event.description)),
                      // ListTile(
                      //     title: const Text("Punkty"),
                      //     subtitle: Text(event.points.toString())),
                      const ListTile (
                          title: Text("Wymagany wiek wolontariusza")),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black.withOpacity(0.05),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.face),
                                    const SizedBox(width: 10),
                                    Text(ageRangeString),
                                  ],
                                )
                              ),
                            )),
                      ),
                      const ListTile (
                          title: Text("Zgłoszeni wolontariusze")),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.black.withOpacity(0.05),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.group),
                                      const SizedBox(width: 10),
                                      Text(numberOfVolunteersText()),
                                    ],
                                  )
                              ),
                            )),
                      ),
                      ListTile(
                          title: const Text("Kontakt do organizatora"),
                          subtitle: Text(event.contactEmail ?? 'Brak'),
                          trailing: event.contactEmail != null ? const Icon(Icons.open_in_new) : null,
                          onTap: () async {
                            if (event.contactEmail != null) {
                              showModalBottomSheet(
                                  shape: bottomSheetShape,
                                  context: context,
                                  builder: (context) => ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        children: [
                                          ListTile(
                                              leading: const Icon(Icons.copy),
                                              title: const Text(
                                                  'Skopiuj do schowka'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: event
                                                            .contactEmail));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Skopiowano do schowka!');
                                              }),
                                          ListTile(
                                              leading: const Icon(Icons.mail),
                                              title: const Text(
                                                  'Wyślij wiadomość'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                launchMailto(
                                                    event.contactEmail!);
                                              })
                                        ],
                                      ));
                            }
                          }),
                    ])),
          )
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
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

  launchMailto(String mail) async {
    final mailtoLink = Mailto(
      to: [mail],
      cc: [],
      subject: event?.title,
      body: '',
    );

    await launchUrl(Uri.parse(mailtoLink.toString()));
  }

  String numberOfVolunteersText() {
    return "${eventVolunteers.length}/${event!.maximalNumberOfVolunteers}";
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
    if (!event!.isMinimalAgeSpecified && !event!.isMaximalAgeSpecified) {
      return "Brak";
    }

    if (event!.isMaximalAgeSpecified) {
      return 'Maksymalnie ${event!.maximalAge} lat';
    }

    if (event!.isMinimalAgeSpecified) {
      return 'Przynajmniej ${event!.minimalAge} lat';
    }

    return '${event!.minimalAge} - ${event!.maximalAge} lat';
  }

  bool canJoin(UserProfile userProfile, List<Volunteer> eventVolunteers) {
    return (event!.maximalNumberOfVolunteers == null ||
            eventVolunteers.length < event!.maximalNumberOfVolunteers!) &&
        isYoungEnough(userProfile) &&
        isOldEnough(userProfile);
  }

  bool isOldEnough(UserProfile userProfile) =>
      event!.minimalAge == null || event!.minimalAge! <= userProfile.age;

  bool isYoungEnough(UserProfile userProfile) =>
      event!.maximalAge == null || event!.maximalAge! >= userProfile.age;

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
