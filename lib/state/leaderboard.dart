import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/leaderboard_options.dart';
import 'package:pomagacze/models/user_profile.dart';

import 'friendships.dart';

final leaderboardProvider =
    FutureProvider.family<List<UserProfile>, LeaderboardOptions>(
        (ref, options) async {
  var friendIds = await ref.watch(friendsIdsProvider.future);
  if (options.type == LeaderboardType.friends) {
    return await UsersDB.getByIds(friendIds, range: options.timeRange);
  }
  return await UsersDB.getAll(range: options.timeRange);
});
