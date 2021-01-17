import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

import 'package:twentyfourtyeight/helper/swipedetector.dart';
import 'package:twentyfourtyeight/widgets/field_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Game game;

  AnimationController controller;

  final double distance = 7;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          List<Tile> tiles = game.getListOfTiles();
          for (int i = 0; i < tiles.length; i++) {
            tiles[i].tileAnimation.x =
                AlwaysStoppedAnimation(tiles[i].lastX.toDouble());

            tiles[i].tileAnimation.y =
                AlwaysStoppedAnimation(tiles[i].lastY.toDouble());

            tiles[i].size = AlwaysStoppedAnimation(0.9);
          }
        });
      }
    });

    game = Game(onGameChanged);
    List<Tile> tiles = game.getListOfTiles();
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].didJustSpawn) {
        tiles[i].bounce(controller);
      }
      tiles[i].tileAnimation.x =
          AlwaysStoppedAnimation(tiles[i].lastX.toDouble());

      tiles[i].tileAnimation.y =
          AlwaysStoppedAnimation(tiles[i].lastY.toDouble());
    }

    super.initState();

    controller.forward(from: 0);
  }

  void onGameChanged() {
    List<Tile> tiles = game.getListOfTiles();

    for (int i = 0; i < tiles.length; i++) {
      int newPosition = game.map.indexWhere(
          (field) => field.hasTile() && field.tile.id == tiles[i].id);
      if (newPosition == -1) {
        throw new Exception("Tile gone missing!");
      }
      int newX = newPosition % 4;
      int newY = (newPosition / 4).floor();

      if (tiles[i].didJustSpawn || tiles[i].hasJustBeenMerged) {
        tiles[i].bounce(controller);
        tiles[i].lastX = newX;
        tiles[i].lastY = newY;
      }

      tiles[i].tileAnimation.x =
          Tween<double>(begin: tiles[i].lastX.toDouble(), end: newX.toDouble())
              .animate(controller);
      tiles[i].tileAnimation.y =
          Tween<double>(begin: tiles[i].lastY.toDouble(), end: newY.toDouble())
              .animate(controller);

      tiles[i].lastX = newX;
      tiles[i].lastY = newY;
    }

    setState(() {
      controller.forward(from: 0);
    });
  }

  double calcPositionOfTile(int position, double size) {
    return position.toDouble() * (size + distance) + distance + size * 0.05;
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width - 32;

    double fieldSize = (totalWidth - distance) / 4 - distance;
    List<Positioned> fields = List<Positioned>.generate(
        16,
        (index) => Positioned(
              top: (index / 4).floor() * (fieldSize + distance) + distance,
              left: (index % 4) * (fieldSize + distance) + distance,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                width: fieldSize,
                height: fieldSize,
              ),
            )).cast<Positioned>();

    List<Tile> tiles = game.getListOfTiles();

    List<AnimatedBuilder> animatedBuilders = tiles
        .map((e) => AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double left = calcPositionOfTile(
                    e.tileAnimation.x.value.floor(), fieldSize);

                double top = calcPositionOfTile(
                    e.tileAnimation.y.value.floor(), fieldSize);

                return TileWidget(
                  left: left - fieldSize * (e.size.value - 0.9) / 2,
                  top: top - fieldSize * (e.size.value - 0.9) / 2,
                  size: fieldSize * e.size.value,
                  value: e.value,
                );
              },
            ))
        .toList()
        .cast<AnimatedBuilder>();

    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SwipeDetector(
            child: Container(
              color: Colors.blue,
              height: double.infinity,
              width: double.infinity,
              child: Center(
                  child: Container(
                height: MediaQuery.of(context).size.width - 32,
                width: MediaQuery.of(context).size.width - 32,
                color: Colors.grey,
                child: Stack(
                  children: [...fields, ...animatedBuilders],
                ),
              )),
            ),
            onSwipeUp: () {
              game.moveUp();
            },
            onSwipeDown: () {
              game.moveDown();
            },
            onSwipeLeft: () {
              game.moveLeft();
            },
            onSwipeRight: () {
              game.moveRight();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({
    Key key,
    @required this.left,
    @required this.top,
    @required this.value,
    @required this.size,
  }) : super(key: key);

  final double left;
  final double top;
  final double size;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(value.toString()),
        ),
      ),
    );
  }
}

/*Column(
                children: [
                  SizedBox(height: 40),
                  Text("Hi Player! ${game.gameOver ? 'Game Over!' : ''}",
                      style: TextStyle(color: Colors.white, fontSize: 22.0)),
                  GridView.count(
                      primary: true,
                      physics: new NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(8.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      crossAxisCount: 4,
                      children: [
                        ...List<int>.generate(16, (i) => i)
                            .map((index) =>
                                FieldWidget(tile: game.map[index].tile))
                            .toList(),
                      ]),
                ],
              ), */
