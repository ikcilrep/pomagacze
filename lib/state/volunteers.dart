import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/utils/constants.dart';

final userEventsProvider = FutureProvider<List<Volunteer>>((ref) async {
  try {
    return await VolunteersDB.getAllByUserId(supabase.auth.user()?.id ?? '');
  } catch (err) {
    if (err is NotFoundError) {
      return [];
    }
    rethrow;
  }
});

final eventVolunteersProvider = FutureProvider.family<List<Volunteer>, String>((ref, eventId) async {
  try {
    return await VolunteersDB.getAllByEventId(eventId);
  } catch (err) {
    if (err is NotFoundError) {
      return [];
    }
    rethrow;
  }
});
