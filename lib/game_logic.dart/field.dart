import 'tile.dart';

class Field {
  final int postion;
  Tile tile;

  Field(this.postion, {this.tile});

  bool hasElement() {
    return tile != null;
  }
}
