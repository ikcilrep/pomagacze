import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/user_profile.dart';
import 'package:pomagacze/utils/constants.dart';

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  return UsersDB.getById(supabase.auth.currentUser?.id ?? '');
});
