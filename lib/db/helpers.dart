import 'package:pomagacze/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotFoundError extends Error {}

extension PostgresResponseThrow<T> on PostgrestResponse<T> {
  void throwOnError({bool expectData = false}) {
    if (hasError && status != 406) {
      print(error);

      if (error?.code == 'PGRST301') {
        supabase.auth.signOut();
      }

      throw error!;
    }
    if (expectData && data == null) {
      throw NotFoundError();
    }
  }
}
