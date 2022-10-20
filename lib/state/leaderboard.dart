import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/leaderboard_options.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

import 'friendships.dart';

final leaderboardProvider =
    FutureProvider.autoDispose.family<List<UserProfile>, LeaderboardOptions>(
        (ref, options) async {
  var friendIds = await ref.watch(friendsIdsProvider.future);
  if (options.type == LeaderboardType.friends) {
    return await UsersDB.getByIds([...friendIds, supabase.auth.user()!.id], range: options.timeRange);
  }
  return await UsersDB.getAll(range: options.timeRange);
});
