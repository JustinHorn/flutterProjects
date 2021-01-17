import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

List<int> getXYofTile(Tile tile, Game game) {
  Function getXOfPosition = (position) => position % 4;
  Function getYOfPosition = (position) => (position / 4).floor();
  int newPosition = game.map
      .indexWhere((field) => field.hasTile() && field.tile.id == tile.id);
  if (newPosition == -1) {
    throw new Exception("Tile gone missing!");
  }
  int newX = getXOfPosition(newPosition);
  int newY = getYOfPosition(newPosition);
  return [newX, newY];
}
