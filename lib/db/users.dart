import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/user_profile.dart';

import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersDB {
  static Future<UserProfile> getById(String id) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .single()
        .execute();

    response.throwOnError(expectData: true);

    return UserProfile.fromData(response.data);
  }

  static Future<bool> profileExists(String id) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .execute(count: CountOption.exact);
    return response.count == 1;
  }

  static Future<void> upsert(UserProfile profile) async {
    final user = supabase.auth.currentUser;
    final updates = {
      ...profile.toJson(),
      'id': user!.id,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    response.throwOnError();
  }

  static Future<List<UserProfile>> getAll() async {
    final response = await supabase.from('profiles').select().execute();
    response.throwOnError();
    return (response.data as List<dynamic>)
        .map((e) => UserProfile.fromData(e))
        .toList();
  }

  static Future<List<UserProfile>> search(String name,
      {String excludeId = '', int limit = 10}) async {
    var query = supabase.from('profiles').select().ilike('name', '%$name%');

    if (excludeId.isNotEmpty) {
      query = query.neq('id', excludeId);
    }

    final response = await query.limit(limit).execute();
    response.throwOnError();
    return (response.data as List<dynamic>)
        .map((e) => UserProfile.fromData(e))
        .toList();
  }
}
