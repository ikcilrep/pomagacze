import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/volunteer.dart';
import 'package:pomagacze/utils/constants.dart';

class VolunteersDB {
  static Future<Volunteer?> get(String eventId, String userId) async {
    var result =
    await supabase.from('volunteers').select().eq('event_id', eventId).eq('user_id', userId).single().execute();
    result.throwOnError();
    return Volunteer.fromData(result.data);
  }

  static Future<void> upsert(Volunteer volunteer) async {
    var result =
        await supabase.from('volunteers').upsert(volunteer.toJson()).execute();
    result.throwOnError();
  }

  static Future<void> update(Volunteer volunteer) async {
    var result =
        await supabase.from('volunteers').update(volunteer.toJson()).execute();
    result.throwOnError();
  }

  static Future<void> deleteByUserId(String userId) async {
    var result = await supabase
        .from('volunteers')
        .delete()
        .eq('user_id', userId)
        .execute();
    result.throwOnError();
  }

  static Future<List<Volunteer>> getAllByUserId(String userId) async {
    var result = await supabase
        .from('volunteers')
        .select()
        .eq('user_id', userId)
        .execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => Volunteer.fromData(e))
        .toList();
  }

  static Future<List<Volunteer>> getAllByEventId(String userId) async {
    var result = await supabase
        .from('volunteers')
        .select()
        .eq('event_id', userId)
        .execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => Volunteer.fromData(e))
        .toList();
  }
}
