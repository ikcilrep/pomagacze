import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

final currentUserIdProvider = Provider((ref) => supabase.auth.currentUser?.id ?? '');

final currentUserProvider = FutureProvider<UserProfile>((ref) async {
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

final userProfileProvider = FutureProvider.family<UserProfile, String>(
    (ref, id) async => await UsersDB.getById(id));

final userProfilesProvider = FutureProvider<List<UserProfile>>((ref) async {
  return await UsersDB.getAll();
});

final searchUsersProvider =
    FutureProvider.family<List<UserProfile>, String>((ref, query) async {
  var currentUser = await ref.watch(currentUserProvider.future);
  return await UsersDB.search(query, excludeId: currentUser.id);
});
