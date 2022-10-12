import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/utils/constants.dart';

class EventsDB {
  static const String select =
      '*, author:author_id(name, avatar_url), volunteers( user_id, profile:user_id ( id, name ) )';

  static Future<List<HelpEvent>> getAll() async {
    var result = await supabase.from('events').select(select).execute();

    result.throwOnError();

    return (result.data as List<dynamic>)
        .map((e) => HelpEvent.fromData(e))
        .toList();
  }

  static Future<List<HelpEvent>> getFiltered(EventFilters filters) async {
    var query = supabase.from('events').select(select);

    if(filters.state == EventState.active) {
      query = query.gt('date_end', DateTime.now().toUtc());
    } else if(filters.state == EventState.past) {
      query = query.lte('date_end', DateTime.now().toUtc());
    }

    if(filters.authorId != null) {
      query = query.eq('author_id', filters.authorId);
    }

    var result = await query.execute();

    result.throwOnError();

    return (result.data as List<dynamic>)
        .map((e) => HelpEvent.fromData(e))
        .toList();
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

  static Future<void> upsert(HelpEvent data) async {
    var result = await supabase.from('events').upsert(data.toJson()).execute();
    result.throwOnError();
  }
}

enum EventState {
  active, past
}

class EventFilters {
  EventState? state;
  String? authorId;

  EventFilters({this.state, this.authorId});
}