import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/pages/event_details.dart';
import 'package:pomagacze/state/activities.dart';
import 'package:pomagacze/utils/date_extensions.dart';

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAndUserActivities =
        ref.watch(friendsAndUserActivitiesProvider);
    return friendsAndUserActivities.when(
        data: (friendsAndUserActivities) {
          friendsAndUserActivities
              .sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return ListView.builder(
              itemCount: friendsAndUserActivities.length,
              itemBuilder: (context, index) {
                final activity = friendsAndUserActivities[index];
                return OpenContainer<bool>(
                    tappable: false,
                    transitionType: ContainerTransitionType.fadeThrough,
                    transitionDuration: const Duration(milliseconds: 350),
                    openBuilder: (BuildContext context, VoidCallback _) =>
                        EventDetails(activity.event),
                    // closedShape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(18)),
                    closedElevation: 1.5,
                    // transitionDuration: const Duration(seconds: 2),
                    closedBuilder: (_, openContainer) {
                      return ListTile(
                        onTap: openContainer,
                        title: Text(
                            '${activity.user.name} dołączył do "${activity.event.title}"'),
                        subtitle: Text(activity.createdAt.displayable()),
                      );
                    });
              });
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
