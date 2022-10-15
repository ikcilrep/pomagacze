import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/activities.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/state/friendships.dart';
import 'package:pomagacze/utils/constants.dart';

final friendsAndUserActivitiesProvider =
    FutureProvider<List<Activity>>((ref) async {
  final userId = supabase.auth.user()?.id ?? '';
  final friendsIds = await ref.watch(friendsIdsProvider.future);
  final activities = <Activity>[];
  for (final id in friendsIds + [userId]) {
    activities.addAll(await ActivitiesDB.getAllByUserId(id));
  }

  return activities;
});

final userActivitiesProvider = FutureProvider.family<List<Activity>, String>(
    (ref, userId) async => ActivitiesDB.getAllByUserId(userId));
