import 'tile.dart';

class Field {
  final int postion;
  Tile tile;

  Field(this.postion, {this.tile});

  bool hasTile() {
    return tile != null;
  }
}
