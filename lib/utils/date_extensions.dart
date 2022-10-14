import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  DateTime applyTimeOfDay({required int hour, required int minute}) {
    return DateTime(year, month, day, hour, minute);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }

  String displayable() {
    return DateFormat('dd.MM.yyyy - kk:mm').format(this);
  }
}