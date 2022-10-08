import 'package:pomagacze/db/helpers.dart';
import 'package:pomagacze/models/help_request.dart';
import 'package:pomagacze/utils/constants.dart';

class RequestsDB {
  static Future<List<HelpRequest>> getAll() async {
    var result = await supabase.from('requests').select().execute();
    result.throwOnError();
    return (result.data as List<dynamic>).map((e) => HelpRequest.fromData(e)).toList();
  }
}