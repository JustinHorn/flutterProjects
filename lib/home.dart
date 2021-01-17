import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

import 'package:twentyfourtyeight/helper/swipedetector.dart';
import 'package:twentyfourtyeight/widgets/tile_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Game game;

  List<TileAnimation> tileAnimations = List.empty(growable: true);

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
          tileAnimations = tileAnimations
              .where((element) => tiles.any((tile) => tile.id == element.id))
              .toList();

          for (int i = 0; i < tiles.length; i++) {
            int index = tileAnimations
                .indexWhere((element) => element.id == tiles[i].id);

            tileAnimations[index].x =
                AlwaysStoppedAnimation(tiles[i].lastX.toDouble());

            tileAnimations[index].y =
                AlwaysStoppedAnimation(tiles[i].lastY.toDouble());

            tileAnimations[index].size = AlwaysStoppedAnimation(0.9);
          }
        });
      }
    });

    game = Game(onGameChanged);
    List<Tile> tiles = game.getListOfTiles();
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].didJustSpawn) {
        tileAnimations.add(TileAnimation(
          tiles[i].id,
          AlwaysStoppedAnimation(tiles[i].lastX.toDouble()),
          AlwaysStoppedAnimation(tiles[i].lastY.toDouble()),
          tiles[i].value,
        ));
        tileAnimations.last.bounce(controller);
      }
    }

    super.initState();

    controller.forward(from: 0);
  }

  void onGameChanged() {
    List<Tile> tiles = game.getListOfTiles();
    tileAnimations = tileAnimations
        .where((element) => tiles.any((tile) => tile.id == element.id))
        .toList();

    for (int i = 0; i < tiles.length; i++) {
      int newPosition = game.map.indexWhere(
          (field) => field.hasTile() && field.tile.id == tiles[i].id);
      if (newPosition == -1) {
        throw new Exception("Tile gone missing!");
      }
      int newX = newPosition % 4;
      int newY = (newPosition / 4).floor();

      if (tiles[i].didJustSpawn || tiles[i].hasJustBeenMerged) {
        tiles[i].lastX = newX;
        tiles[i].lastY = newY;
        tileAnimations.add(TileAnimation(
          tiles[i].id,
          Tween<double>(begin: tiles[i].lastX.toDouble(), end: newX.toDouble())
              .animate(controller),
          Tween<double>(begin: tiles[i].lastY.toDouble(), end: newY.toDouble())
              .animate(controller),
          tiles[i].value,
        ));

        tileAnimations.last.bounce(controller);
      } else {
        TileAnimation animation =
            tileAnimations.firstWhere((element) => element.id == tiles[i].id);

        animation.x = Tween<double>(
                begin: tiles[i].lastX.toDouble(), end: newX.toDouble())
            .animate(controller);

        animation.y = Tween<double>(
                begin: tiles[i].lastY.toDouble(), end: newY.toDouble())
            .animate(controller);

        tiles[i].lastX = newX;
        tiles[i].lastY = newY;
      }
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

    List<AnimatedBuilder> animatedBuilders = tileAnimations
        .map((animation) => AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double left =
                    calcPositionOfTile(animation.x.value.floor(), fieldSize);

                double top =
                    calcPositionOfTile(animation.y.value.floor(), fieldSize);

                return TileWidget(
                  left: left - fieldSize * (animation.size.value - 0.9) / 2,
                  top: top - fieldSize * (animation.size.value - 0.9) / 2,
                  size: fieldSize * animation.size.value,
                  value: animation.value,
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
