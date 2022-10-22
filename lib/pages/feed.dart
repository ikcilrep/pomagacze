import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/event_list.dart';
import 'package:pomagacze/components/fab_extended_animated.dart';
import 'package:pomagacze/components/segmented_control.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/pages/event_form.dart';
import 'package:pomagacze/state/events.dart';
import 'package:pomagacze/state/users.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends ConsumerState<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  EventFilters _eventFilters =
      const EventFilters(orderBy: EventOrder.closest, state: EventState.active);

  @override
  void initState() {
    super.initState();
    var userProfile = ref.read(currentUserProvider);

    _eventFilters = _eventFilters.copyWith(
        currentLat: userProfile.valueOrNull?.latitude,
        currentLng: userProfile.valueOrNull?.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(),
        ),
        _buildList(),
        _buildFAB(),
      ],
    );
  }

  Widget _buildFAB() {
    return Positioned(
        bottom: 15,
        right: 10,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: OpenContainer<bool>(
              tappable: false,
              transitionType: ContainerTransitionType.fadeThrough,
              transitionDuration: const Duration(milliseconds: 350),
              closedElevation: 1.5,
              openBuilder: (BuildContext context, VoidCallback _) {
                return const EventForm();
              },
              openShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              closedColor: Theme.of(context).colorScheme.primary,
              closedBuilder: (_, openContainer) {
                return ScrollingFabAnimated(
                  scrollController: _scrollController,
                  text: Text('Nowe wydarzenie',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary)),
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.onSecondary),
                  onPress: openContainer,
                  radius: 18,
                  width: 185,
                  elevation: 10,
                  animateIcon: false,
                  color: Theme.of(context).colorScheme.secondary,
                  duration: const Duration(milliseconds: 150),
                );
              }),
        ));
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedControl(
            children: const {
              EventOrder.closest: Text('Blisko ciebie'),
              EventOrder.incoming: Text('Nadchodzące'),
              EventOrder.popular: Text('Popularne'),
            },
            selectionIndex: _eventFilters.orderBy,
            horizontalPadding: const EdgeInsets.symmetric(horizontal: 7),
            onSegmentChosen: (value) {
              setState(() {
                _eventFilters = _eventFilters.copyWith(orderBy: value);
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          Expanded(
            child: PageTransitionSwitcher(
                transitionBuilder: (child, animation, secondaryAnimation) {
                  return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child);
                },
                child: EventList(
                    key: Key(_eventFilters.hashCode.toString()),
                    provider: filteredEventsFutureProvider(_eventFilters),
                    scrollController: _scrollController)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
