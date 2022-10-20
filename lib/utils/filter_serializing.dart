import 'package:pomagacze/db/db.dart';

extension OrderBySerializing on EventOrder {
  String display() {
    switch (this) {
      case EventOrder.incoming:
        return "Nadchodzące";
      case EventOrder.closest:
        return "Blisko ciebie";
      case EventOrder.popular:
        return "Popularne";
      default:
        return "";
    }
  }
}
