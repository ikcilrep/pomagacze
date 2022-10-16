import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsDB {
  static const String select =
      '*, author:author_id(name, avatar_url), volunteers( created_at, user_id, profile:user_id ( id, name ) )';

  static const String selectInner =
      '*, author:author_id(name, avatar_url), volunteers!inner( created_at, user_id, profile:user_id ( id, name ) )';

  static Future<List<HelpEvent>> getAll() async {
    var result = await supabase.from('events').select(select).execute();

    result.throwOnError();

    return (result.data as List<dynamic>)
        .map((e) => HelpEvent.fromData(e))
        .toList();
  }

  static Future<List<HelpEvent>> getFiltered(EventFilters filters) async {
    PostgrestFilterBuilder query;

    if (filters.orderBy == EventOrder.closest) {
      query = supabase.rpc('closest_events',
          params: {'lat': filters.currentLat, 'lng': filters.currentLng});
    } else {
      query = supabase.from('events_extended').select(select);
    }

    query = applyFilters(query, filters);

    PostgrestTransformBuilder q2;
    if (filters.orderBy == EventOrder.closest) {
      q2 = query.select(select);
    } else if (filters.orderBy == EventOrder.incoming) {
      q2 = query.order('date_start', ascending: true);
    } else {
      q2 = query.order('volunteer_count');
    }

    var result = await q2.execute();
    result.throwOnError();

    return (result.data as List<dynamic>)
        .map((e) => HelpEvent.fromData(e))
        .toList();
  }

  static Future<List<HelpEvent>> getByVolunteer(EventFilters filters) async {
    var query = supabase
        .from('events_extended')
        .select(selectInner)
        .eq('volunteers.user_id', filters.volunteerId);

    var result = await applyFilters(query, filters).execute();
    result.throwOnError();

    return (result.data as List<dynamic>)
        .map((e) => HelpEvent.fromData(e))
        .toList();
  }

  static PostgrestFilterBuilder applyFilters(
      PostgrestFilterBuilder query, EventFilters filters) {
    if (filters.state == EventState.active) {
      query = query.gt('date_end', DateTime.now());
    } else if (filters.state == EventState.past) {
      query = query.lte('date_end', DateTime.now());
    }

    if (filters.authorId != null) {
      query = query.eq('author_id', filters.authorId);
    }

    return query;
  }

  static Future<HelpEvent> getById(String id) async {
    var result = await supabase
        .from('events')
        .select(select)
        .eq('id', id)
        .single()
        .execute();

    result.throwOnError();

    return HelpEvent.fromData(result.data);
  }

  static Future<HelpEvent> upsert(HelpEvent data) async {
    var result = await supabase.from('events').upsert(data.toJson()).execute();
    result.throwOnError();
    return HelpEvent.fromData(result.data[0]);
  }
}

enum EventState { active, past }

enum EventOrder { incoming, closest, popular }

class EventFilters {
  EventState? state;
  String? authorId;
  String? volunteerId;
  EventOrder? orderBy;

  double? currentLat, currentLng;

  EventFilters(
      {this.state,
      this.authorId,
      this.volunteerId,
      this.orderBy,
      this.currentLat,
      this.currentLng});

  EventFilters.empty();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventFilters &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          authorId == other.authorId &&
          volunteerId == other.volunteerId &&
          orderBy == other.orderBy &&
          currentLat == other.currentLat &&
          currentLng == other.currentLng;

  @override
  int get hashCode =>
      state.hashCode ^
      authorId.hashCode ^
      volunteerId.hashCode ^
      orderBy.hashCode ^
      currentLat.hashCode ^
      currentLng.hashCode;
}
