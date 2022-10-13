import 'package:pomagacze/db/helpers.dart';
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
}