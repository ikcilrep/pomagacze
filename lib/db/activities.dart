import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/utils/constants.dart';

class ActivitiesDB {
  static Future<List<Activity>> getActivitiesForUsers(List<String> userIds) async {
    var result = await supabase
        .from('volunteers')
        .select('*, event:event_id(*), user:user_id(*)')
        .in_('user_id', userIds)
        .order('created_at')
        .execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => Activity.fromData(e))
        .toList();
  }

  static Future<List<Activity>> getActivitiesForUser(String userId) async {
    return await getActivitiesForUsers([userId]);
  }
}
