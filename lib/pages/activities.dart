import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          return ListView.builder(
              itemCount: friendsAndUserActivities.length,
              itemBuilder: (context, index) {
                final activity = friendsAndUserActivities[index];
                return ListTile(
                  title: Text(
                      "${activity.user.name} dołączył do ${activity.event.title}"),
                  subtitle: Text(
                      "Data dołączenia ${activity.createdAt.displayable()}"),
                );
              });
        },
        error: (err, stack) => Center(child: Text('Coś poszło nie tak: $err')),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
