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
          }
        });
      }
    });

    game = Game(onGameChanged);
    List<Tile> tiles = game.getListOfTiles();
    for (int i = 0; i < tiles.length; i++) {
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

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width - 32;

    double size = (totalWidth - distance) / 4 - distance;
    List<Positioned> fields = List<Positioned>.generate(
        16,
        (index) => Positioned(
              top: (index / 4).floor() * (size + distance) + distance,
              left: (index % 4) * (size + distance) + distance,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                width: size,
                height: size,
              ),
            )).cast<Positioned>();

    List<Tile> tiles = game.getListOfTiles();

    List<AnimatedBuilder> animatedBuilders = tiles
        .map((e) => AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Positioned(
                  left: e.tileAnimation.x.value.floor().toDouble() *
                          (size + distance) +
                      distance +
                      size * 0.05,
                  top: e.tileAnimation.y.value.floor().toDouble() *
                          (size + distance) +
                      distance +
                      size * 0.05,
                  child: Container(
                    width: size * 0.9,
                    height: size * 0.9,
                    color: Colors.grey[400],
                    child: Center(
                      child: Text(e.value.toString()),
                    ),
                  ),
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
