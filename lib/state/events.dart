import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomagacze/db/db.dart';
import 'package:pomagacze/models/help_event.dart';

final feedFutureProvider = FutureProvider<bool>((ref) async => true);

final filteredEventsFutureProvider =
    FutureProvider.family<List<HelpEvent>, EventFilters>((ref, filters) async {
  await ref.watch(feedFutureProvider.future);

  return await EventsDB.getFiltered(filters);
});

final eventsWithVolunteerFutureProvider =
    FutureProvider.family<List<HelpEvent>, EventFilters>((ref, filters) async {
  await ref.watch(feedFutureProvider.future);

  return await EventsDB.getByVolunteer(filters);
});

final eventFutureProvider =
    FutureProvider.family<HelpEvent, String>((ref, id) async {
  return await EventsDB.getById(id);
});
