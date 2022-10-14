import 'package:pomagacze/db/events.dart';
import 'package:pomagacze/db/users.dart';
import 'package:pomagacze/db/volunteers.dart';
import 'package:pomagacze/models/activity.dart';
import 'package:pomagacze/models/help_event.dart';
import 'package:pomagacze/models/volunteer.dart';

class ActivitiesDB {
  static Future<List<Activity>> getAllByUserId(String userId) async {
    final events =
        await EventsDB.getByVolunteer(EventFilters(volunteerId: userId));
    final volunteer = await VolunteersDB.getAllByUserId(userId);
    final user = await UsersDB.getById(userId);
    return events
        .map((event) => Activity(user, event, _joiningDate(volunteer, event)))
        .toList();
  }

  static DateTime _joiningDate(List<Volunteer> volunteer, HelpEvent event) =>
      volunteer.firstWhere((v) => v.eventId == event.id).createdAt;
}
