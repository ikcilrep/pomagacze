extension DateTimeExt on DateTime {
  DateTime applyTimeOfDay({required int hour, required int minute}) {
    return DateTime(year, month, day, hour, minute);
  }
}