import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/friend_request.dart';
import 'package:pomagacze/models/friendship.dart';
import 'package:pomagacze/utils/constants.dart';

class FriendshipsDB {
  static Future<List<Friendship>> getFriendshipsOf(String userId) async {
    final result = await supabase
        .from('friendships')
        .select()
        .or('user1_id.eq.$userId,user2_id.eq.$userId')
        .execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => Friendship.fromData(e))
        .toList();
  }

  static Future<void> removeFriendship(String user1Id, String user2Id) async {
    await supabase
        .from('friendships')
        .delete()
        .or('and(user1_id.eq.$user1Id,user2_id.eq.$user2Id),and(user1_id.eq.$user2Id,user2_id.eq.$user1Id)')
        .execute();
  }

  static Future<void> sendFriendRequest(
      String senderId, String targetId) async {
    await supabase
        .from('friend_requests')
        .upsert({'sender_id': senderId, 'target_id': targetId}).execute();
  }

  static Future<void> cancelFriendRequest(
      String senderId, String targetId) async {
    await supabase
        .from('friend_requests')
        .delete()
        .eq('sender_id', senderId)
        .eq('target_id', targetId)
        .execute();
  }

  static Future<void> acceptFriendRequest(String senderId, String targetId) async {
    await cancelFriendRequest(senderId, targetId);
    await supabase.from('friendships').upsert({
      'user1_id': senderId,
      'user2_id': targetId
    }).execute();
  }

  static Future<List<FriendRequest>> getIncomingFriendRequests(
      String userId) async {
    final result = await supabase
        .from('friend_requests')
        .select('*, target:target_id(*), sender:sender_id(*)')
        .eq('target_id', userId)
        .execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => FriendRequest.fromData(e))
        .toList();
  }

  static Future<List<FriendRequest>> getOutgoingFriendRequests(
      String userId) async {
    final result = await supabase
        .from('friend_requests')
        .select('*, target:target_id(*), sender:sender_id(*)')
        .eq('sender_id', userId)
        .execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => FriendRequest.fromData(e))
        .toList();
  }
}
