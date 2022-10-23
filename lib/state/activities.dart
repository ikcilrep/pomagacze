import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/activities.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/state/users.dart';

final activitiesProvider = FutureProvider<List<Activity>>((ref) async {
  final friendIds = await ref.watch(friendsIdsProvider.future);
  final currentUserId = ref.watch(currentUserIdProvider);
  final friendsAndUserActivities =
      await ActivitiesDB.getActivitiesForUsers([...friendIds, currentUserId]);
  final volunteerActivities =
      await ActivitiesDB.getActivitiesForOrganizerVolunteers(currentUserId);

  return [
    ...friendsAndUserActivities,
    ..._withoutUsers(volunteerActivities, [currentUserId, ...friendIds])
  ];
});

Iterable<Activity> _withoutUsers(
    List<Activity> volunteerActivities, List<String> userIds) {
  return volunteerActivities
      .where((activity) => !userIds.contains(activity.user.id));
}

final userActivitiesProvider = FutureProvider.family<List<Activity>, String>(
    (ref, userId) async => ActivitiesDB.getActivitiesForUsers([userId]));
