import 'package:intl/intl.dart';
import 'package:powers/powers.dart';

const x = 0.3;
const y = 2;

int levelFromXP(int xp) {
  return (x * xp.root(y)).floor();
}

int xpRequiredForLevel(int level) {
  return ((level / x).pow(y)).floor();
}

String formatXP(int xp) {
  return xp < 10000
      ? xp.toString()
      : NumberFormat.compact(locale: 'en').format(xp);
}

double getProgressToNextLevel(int xp) {
  var currentLevel = levelFromXP(xp);
  var lowerBound = xpRequiredForLevel(currentLevel);
  var upperBound = xpRequiredForLevel(currentLevel + 1);

  return (xp - lowerBound) / (upperBound - lowerBound);
}
