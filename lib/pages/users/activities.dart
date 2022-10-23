import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/components/general/error_with_action.dart';
import 'package:pomagacze/pages/events/event_details.dart';
import 'package:pomagacze/state/activities.dart';
import 'package:pomagacze/utils/date_extensions.dart';

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities =
        ref.watch(activitiesProvider);

    return activities.when(
        data: (data) {
          if (data.isEmpty) {
            return ErrorWithAction(
                errorText: 'Brak aktualności',
                action: () {
                  Navigator.of(context).pushNamed('/search-users');
                },
                actionText: 'Dodaj znajomych');
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.refresh(activitiesProvider.future),
            child: ListView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemBuilder: (context, index) {
                  final activity = data[index];
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
                      closedColor: Colors.transparent,
                      closedBuilder: (_, openContainer) {
                        return ListTile(
                          onTap: openContainer,
                          title: Text(
                              '${activity.user.name} dołączył do "${activity.event.title}"'),
                          subtitle: Text(activity.createdAt.displayable()),
                        );
                      });
                }),
          );
        },
        error: (err, stack) => ErrorWithAction(
            error: err,
            action: () {
              ref.invalidate(activitiesProvider);
            },
            actionText: 'Odśwież'),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
