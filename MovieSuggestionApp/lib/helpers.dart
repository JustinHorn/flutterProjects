import 'dart:math';

class UniqueRandomNumber {
  List<int> _numbers = [];

  int getUniqueRandomNumber(int range) {
    if (_numbers.length != range) {
      _numbers = List.generate(range, (index) => -1);
    }
    var rng = new Random();
    int nextInt = rng.nextInt(range);

    if (_numbers[nextInt] == -1) {
      _numbers[nextInt] = 1;
      return nextInt;
    } else {
      for (int i = 0; i < range - 1; i++) {
        nextInt++;
        if (nextInt == range) {
          nextInt = 0;
        }
        if (_numbers[nextInt] == -1) {
          _numbers[nextInt] = 1;
          return nextInt;
        }
      }
      throw Exception("Numbers is full! Range: " + range.toString());
    }
  }
}
