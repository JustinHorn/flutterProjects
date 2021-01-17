import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

import 'package:twentyfourtyeight/helper/swipedetector.dart';
import 'package:twentyfourtyeight/helper/tile_animation_controller.dart';
import 'package:twentyfourtyeight/widgets/tile_animations.dart';
import 'package:twentyfourtyeight/widgets/tile_widget.dart';

import 'helper/functions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Game game;

  AnimationController controller;

  TileAnimationController tileAnimationController;

  final double distance = 7;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    tileAnimationController = TileAnimationController(controller);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          List<Tile> tiles = game.getListOfTiles();

          tileAnimationController
              .filterAnimationsByIds(tiles.map((t) => t.id).cast<int>());

          tileAnimationController.setAnimationsToStop(tiles);
        });
      }
    });

    game = Game(onGameChanged);
    List<Tile> tiles = game.getListOfTiles();
    tileAnimationController.initTiles(tiles);

    super.initState();

    controller.forward(from: 0);
  }

  void onGameChanged() {
    List<Tile> tiles = game.getListOfTiles();
    List<Tile> previousTiles = game.getListOfPreviousTiles();

    tileAnimationController.animate(tiles, previousTiles, game);
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

    List<AnimatedBuilder> animatedBuilders =
        tileAnimationController.getAnimatedTileBuilders(fieldSize, distance);

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
