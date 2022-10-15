import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/event_list.dart';
import 'package:pomagacze/components/fab_extended_animated.dart';
import 'package:pomagacze/pages/event_form.dart';
import 'package:pomagacze/state/events.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends ConsumerState<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
                          color: Theme.of(context).colorScheme.onPrimary)),
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.onPrimary),
                  onPress: openContainer,
                  radius: 18,
                  width: 185,
                  elevation: 10,
                  animateIcon: false,
                  color: Theme.of(context).colorScheme.primary,
                  duration: const Duration(milliseconds: 150),
                );
              }),
        ));
  }

  Widget _buildList() {
    return EventList(
        provider: feedFutureProvider, scrollController: _scrollController);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
