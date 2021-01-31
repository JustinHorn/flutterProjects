import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

import 'package:twentyfourtyeight/widgets/gamemapbuilder.dart';
import 'package:twentyfourtyeight/widgets/swipedetector.dart';
import 'package:twentyfourtyeight/widgets/tile_widget.dart';

import 'animations/tile_animation_controller.dart';
import 'animations/tile_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Game game;

  AnimationController controller;

  TileAnimationController tileAnimationController;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    initGame();
    super.initState();
  }

  void initGame() {
    game = Game();

    tileAnimationController = TileAnimationController(controller, game);

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

    game.onGameMapChange = onGameChanged;
    tileAnimationController.loadFirstTiles();
    controller.forward(from: 0);
  }

  void onGameChanged() {
    tileAnimationController.animate();
    setState(() {
      controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Title(
                  color: Colors.black,
                  child: Text(
                    "Your score is: ${game.getScore()}",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )),
              SizedBox(
                height: 20,
              ),
              SwipeDetector(
                child: Container(
                    height: MediaQuery.of(context).size.width - 32,
                    width: MediaQuery.of(context).size.width - 32,
                    color: Colors.grey,
                    child: GameMapBuilder(
                      tileAnimations: tileAnimationController.tileAnimations,
                      controller: controller,
                    )),
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
              FlatButton(
                  onPressed: () {
                    initGame();
                    setState(() => null);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Text(
                      'Reset Game',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ))
            ],
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
