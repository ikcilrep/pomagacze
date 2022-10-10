import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/utils/constants.dart';

class EventsDB {
  static Future<List<HelpEvent>> getAll() async {
    var result = await supabase.from('requests').select().execute();
    result.throwOnError();
    return (result.data as List<dynamic>)
        .map((e) => HelpEvent.fromData(e))
        .toList();
  }

  static Future<void> upsert(HelpEvent data) async {
    var result =
        await supabase.from('requests').upsert(data.toJson()).execute();
    result.throwOnError();
  }
}
