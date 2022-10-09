import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/user_profile.dart';

import 'package:pomagacze/utils/constants.dart';

class UsersDB {
  static Future<UserProfile> getById(String id) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .execute();
    response.throwOnError();

    return UserProfile.fromData(response.data);
  }

  static Future<void> update(UserProfile profile) async {
    final user = supabase.auth.currentUser;
    final updates = {
      ...profile.toJson(),
      'id': user!.id,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    response.throwOnError();
  }
}