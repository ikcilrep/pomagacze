import 'package:pomagacze/models/user_profile.dart';

import 'package:pomagacze/utils/constants.dart';

import 'package:pomagacze/utils/gender_serializing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension UserProfileUpdates on UserProfile {
  static Future<UserProfile> fetchFromDatabase(String userId, {required void Function(String) onError}) async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      onError(error.message);
      return UserProfile.empty();
    }

    final data = response.data;
    final profile = UserProfile.fromData(data);

    return profile;
  }

  Future<PostgrestError?> pushToDatabase() async {
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'name': name,
      'birth_date': birthDate?.toIso8601String().toString(),
      'gender': gender?.serialize().toString(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();

    return response.error;
  }
}