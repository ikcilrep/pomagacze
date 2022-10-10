import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/fab_extended_animated.dart';
import 'package:pomagacze/components/event_card.dart';
import 'package:pomagacze/pages/event_form.dart';
import 'package:pomagacze/state/feed.dart';

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
        child: OpenContainer<bool>(
            transitionType: ContainerTransitionType.fadeThrough,
            openBuilder: (BuildContext context, VoidCallback _) {
              return const EventForm();
            },
            tappable: false,
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            closedElevation: 1.5,
            // transitionDuration: const Duration(seconds: 2),
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
                elevation: 1.5,
                animateIcon: false,
                color: Theme.of(context).colorScheme.primary,
                duration: const Duration(milliseconds: 150),
              );
            }));
  }

  Widget _buildList() {
    var future = ref.watch(feedFutureProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(feedFutureProvider.future),
      child: future.when(
          data: (data) => ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) => EventCard(data[index]),
              itemCount: data.length),
          error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Coś poszło nie tak...'),
                    const SizedBox(height: 5),
                    ElevatedButton(
                        onPressed: () {
                          ref.invalidate(feedFutureProvider);
                        },
                        child: Text('Odśwież'))
                  ],
                ),
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
