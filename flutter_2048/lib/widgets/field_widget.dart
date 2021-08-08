import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({
    Key key,
    this.tile,
  }) : super(key: key);

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      child: Center(
        child: Text(
          (tile != null) ? tile.toString() : "",
          style: TextStyle(color: Colors.white, fontSize: 22.0),
        ),
      ),
    );
  }
}
