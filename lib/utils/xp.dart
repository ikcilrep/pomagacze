import 'package:powers/powers.dart';

const x = 0.3;
const y = 2;

int levelFromXP(int xp) {
  return (x * xp.root(y)).floor();
}