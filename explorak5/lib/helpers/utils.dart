import 'dart:math';

class IntIDGenerator {
  int current;
  final _rnd = new Random();
  final maxRandInt;

  IntIDGenerator(
      {this.current = 0, this.maxRandInt = 9999, initRandom = false}) {
    if (initRandom) {
      this.current = _rnd.nextInt(this.maxRandInt);
    }
  }

  int next() {
    return ++current;
  }

  int nextRand() {
    current += _rnd.nextInt(this.maxRandInt) + 1;
    return current;
  }

  List<int> take(int count, {bool random = false}) {
    final List<int> result = [];
    count = count < 1 ? 1 : count;
    while (count-- > 0) {
      int newInt = random ? nextRand() : next();
      result.add(newInt);
    }
    return result;
  }
}
