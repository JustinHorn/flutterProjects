import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

import 'package:twentyfourtyeight/helper/swipedetector.dart';
import 'package:twentyfourtyeight/widgets/field_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Game game;

  @override
  void initState() {
    game = Game(() => setState(() => null));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SwipeDetector(
          child: Container(
            color: Colors.blue,
            height: double.infinity,
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text("Hi Player! ${game.gameOver ? 'Game Over!' : ''}",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: GridView.count(
                        primary: true,
                        physics: new NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(8.0),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        crossAxisCount: 4,
                        children: List<int>.generate(16, (i) => i)
                            .map((index) =>
                                FieldWidget(tile: game.map[index].tile))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    );
  }
}
