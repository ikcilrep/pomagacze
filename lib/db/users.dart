import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/user_profile.dart';

import 'package:pomagacze/utils/constants.dart';

import 'package:pomagacze/utils/gender_serializing.dart';

class UsersDB {
  static Future<UserProfile> getByID(String id) async {
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
      'id': user!.id,
      'name': profile.name,
      'birth_date': profile.birthDate?.toIso8601String().toString(),
      'gender': profile.gender?.serialize().toString(),
      'updated_at': DateTime.now().toIso8601String(),
      'latitude': profile.latitude,
      'longitude': profile.longitude,
      'place_name': profile.placeName,
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    response.throwOnError();
  }
}