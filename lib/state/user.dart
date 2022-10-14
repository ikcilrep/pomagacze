import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  try {
    return await UsersDB.getById(supabase.auth.user()?.id ?? '');
  } catch (err) {
    if (err is NotFoundError) {
      return UserProfile.empty();
    } else {
      rethrow;
    }
  }
});

final userProfilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  return await UsersDB.getAll();
});
