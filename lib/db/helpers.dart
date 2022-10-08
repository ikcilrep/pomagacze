import 'package:supabase_flutter/supabase_flutter.dart';

extension PostgresResponseThrow<T> on PostgrestResponse<T> {
  void throwOnError() {
    if (hasError && status != 406) {
      throw error!;
    }
  }
}