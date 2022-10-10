import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_event.dart';

final feedFutureProvider = FutureProvider<List<HelpEvent>>((ref) async {
    return await EventsDB.getAll();
});
