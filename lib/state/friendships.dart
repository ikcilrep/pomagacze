import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/db/friendships.dart';
import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

final friendsIdsProvider = FutureProvider<List<String>>((ref) async {
  final userId = supabase.auth.user()?.id ?? '';
  final friendships = await FriendshipsDB.getFriendshipsOf(userId);
  return friendships.map((e) => e.user1Id == userId ? e.user2Id : e.user1Id).toList();
});

final friendsAndUserProfilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  try {
    final userId = supabase.auth.user()?.id ?? '';
    final friendsIds = await ref.watch(friendsIdsProvider.future);
    List<UserProfile> result = await _getAllByIds(friendsIds, userId);
    return result;
  } catch (err) {
    if (err is NotFoundError) {
      return [];
    }
    rethrow;
  }
});

Future<List<UserProfile>> _getAllByIds(List<String> friendsIds, String userId) async {
  final result = <UserProfile>[];
  for (final friendId in friendsIds) {
    result.add(await UsersDB.getById(friendId));
  }
  result.add(await UsersDB.getById(userId));
  return result;
}
