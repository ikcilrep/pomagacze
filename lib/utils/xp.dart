import 'package:intl/intl.dart';
import 'package:powers/powers.dart';

const x = 0.3;
const y = 2;

int levelFromXP(int xp) {
  return (x * xp.root(y)).floor();
}

String formatXP(int xp) {
  return NumberFormat.compact(locale: 'en')
      .format(xp);
}