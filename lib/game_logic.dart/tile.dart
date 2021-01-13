class Tile {
  final int value;
  bool hasJustBeenMerged;

  Tile(this.value, {this.hasJustBeenMerged = false});

  bool operator ==(other) => other is Tile && other.value == value;

  static Tile merge(Tile a, Tile b) {
    return Tile(a.value + b.value, hasJustBeenMerged: true);
  }

  @override
  String toString() {
    // TODO: implement toString
    return value.toString();
  }
}
