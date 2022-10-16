import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/db/friendships.dart';
import 'package:pomagacze/models/friend_request.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

final friendsIdsProvider = FutureProvider<List<String>>((ref) async {
  final userId = supabase.auth.user()?.id ?? '';
  final friendships = await FriendshipsDB.getFriendshipsOf(userId);
  return friendships
      .map((e) => e.user1Id == userId ? e.user2Id : e.user1Id)
      .toList();
});

final friendsProvider = FutureProvider<List<UserProfile>>((ref) async {
  final friendsIds = await ref.watch(friendsIdsProvider.future);
  return await UsersDB.getByIds(friendsIds);
});

final friendsAndUserProfilesProvider =
    FutureProvider<List<UserProfile>>((ref) async {
      final userId = supabase.auth.user()?.id ?? '';
  final friendsIds = await ref.watch(friendsIdsProvider.future);
  var res = await UsersDB.getByIds([...friendsIds, userId]);
  return res;
});

final outgoingFriendRequestsProvider =
    FutureProvider.autoDispose<List<FriendRequest>>((ref) async {
  ref.watch(friendsIdsProvider.future);

  final userId = supabase.auth.user()?.id ?? '';
  return await FriendshipsDB.getOutgoingFriendRequests(userId);
});

final incomingFriendRequestsProvider =
    FutureProvider.autoDispose<List<FriendRequest>>((ref) async {
  ref.watch(friendsIdsProvider.future);

  final userId = supabase.auth.user()?.id ?? '';
  return await FriendshipsDB.getIncomingFriendRequests(userId);
});
