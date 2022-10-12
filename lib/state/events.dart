import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_event.dart';

final feedFutureProvider = FutureProvider<List<HelpEvent>>((ref) async {
  return await EventsDB.getAll();
});

final filteredEventsFutureProvider =
    FutureProvider.family<List<HelpEvent>, EventFilters>((ref, filters) async {

  await ref.watch(feedFutureProvider.future);

  return await EventsDB.getFiltered(filters);
});

final eventFutureProvider =
    FutureProvider.family<HelpEvent, String>((ref, id) async {
  return await EventsDB.getById(id);
});
