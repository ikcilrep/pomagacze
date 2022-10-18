import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/activities.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/state/user.dart';

final friendsAndUserActivitiesProvider =
    FutureProvider<List<Activity>>((ref) async {
  var friendIds = await ref.watch(friendsIdsProvider.future);
  var userProfile = await ref.watch(userProfileProvider.future);
  return await ActivitiesDB.getActivitiesForUsers([...friendIds, userProfile.id]);
});

final userActivitiesProvider = FutureProvider.family<List<Activity>, String>(
    (ref, userId) async => ActivitiesDB.getActivitiesForUsers([userId]));
