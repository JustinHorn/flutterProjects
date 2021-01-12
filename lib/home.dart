import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:twentyfourtyeight/helper/swipedetector.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Field> gameMap;

  @override
  void initState() {
    gameMap = List<Field>.generate(16, (index) => Field(index, element: 2));
    gameMap[0].element = 2;
    gameMap[1].element = 2;

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
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.count(
                  primary: true,
                  physics: new NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  crossAxisCount: 4,
                  children: List<int>.generate(16, (i) => i)
                      .map((index) => Container(
                            color: Colors.brown,
                            child: Text(gameMap[index].hasElement()
                                ? gameMap[index].element.toString()
                                : ""),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          onSwipeUp: () {
            moveUp();
          },
          onSwipeDown: () {
            print("move down");
            moveDown();
          },
          onSwipeLeft: () {
            print("move left");
            moveLeft();
          },
          onSwipeRight: () {
            moveRight();
          },
        ),
      ),
    );
  }

  moveLeft() {
    for (int i = 0; i < 4; i++) {
      for (int j = 1; j < 4; j++) {
        int index = i * 4 + j;
        int nextLine = (i * 4 - 1);

        if (gameMap[index].hasElement()) {
          int next = index - 1;
          if (!gameMap[next].hasElement()) {
            while (next - 1 > nextLine && !gameMap[next - 1].hasElement()) {
              next -= 1;
            }

            if (next - 1 > nextLine &&
                gameMap[next - 1].hasElement() &&
                gameMap[index].element == gameMap[next - 1].element) {
              gameMap[index].element += gameMap[next - 1].element;
              gameMap[next].element = -1;
              next -= 1;
            }

            gameMap[next].element = gameMap[index].element;
            gameMap[index].element = -1;
          } else if (gameMap[next].element == gameMap[index].element) {
            gameMap[index].element += gameMap[next].element;
            gameMap[next].element = -1;
            gameMap[next].element = gameMap[index].element;
            gameMap[index].element = -1;
          }
        }
      }
    }
    setState(() {});
  }

  moveRight() {
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j >= 0; j--) {
        int index = i * 4 + j;
        int nextLine = ((i + 1) * 4);

        if (gameMap[index].hasElement()) {
          int next = index + 1;
          if (!gameMap[next].hasElement()) {
            while (next + 1 < nextLine && !gameMap[next + 1].hasElement()) {
              next += 1;
            }

            if (next + 1 < nextLine &&
                gameMap[next + 1].hasElement() &&
                gameMap[index].element == gameMap[next + 1].element) {
              gameMap[index].element += gameMap[next + 1].element;
              gameMap[next].element = -1;
              next = next + 1;
            }

            gameMap[next].element = gameMap[index].element;
            gameMap[index].element = -1;
          } else if (gameMap[next].element == gameMap[index].element) {
            gameMap[index].element += gameMap[next].element;
            gameMap[next].element = -1;
            gameMap[next].element = gameMap[index].element;
            gameMap[index].element = -1;
          }
        }
      }
    }
    setState(() {});
  }

  moveUp() {
    for (int i = 4; i < gameMap.length; i++) {
      int index = i;
      if (gameMap[i].hasElement()) {
        int next = i - 4;
        if (!gameMap[next].hasElement()) {
          while (next - 4 >= 0 && !gameMap[next - 4].hasElement()) {
            next -= 4;
          }

          if (next - 4 >= 0 &&
              gameMap[next - 4].hasElement() &&
              gameMap[index].element == gameMap[next - 4].element) {
            gameMap[index].element += gameMap[next - 4].element;
            gameMap[next].element = -1;
            next -= 4;
          }

          gameMap[next].element = gameMap[i].element;
          gameMap[i].element = -1;
        } else if (gameMap[next].element == gameMap[index].element) {
          gameMap[index].element += gameMap[next].element;
          gameMap[next].element = -1;
          gameMap[next].element = gameMap[index].element;
          gameMap[index].element = -1;
        }
      }
    }
    setState(() {});
  }

  moveDown() {
    for (int i = gameMap.length - 5; i >= 0; i--) {
      int index = i;
      if (gameMap[i].hasElement()) {
        int next = i + 4;
        if (!gameMap[i + 4].hasElement()) {
          while (next + 4 < gameMap.length && !gameMap[next + 4].hasElement()) {
            next += 4;
          }

          if (next + 4 < gameMap.length &&
              gameMap[next + 4].hasElement() &&
              gameMap[index].element == gameMap[next + 4].element) {
            gameMap[index].element += gameMap[next + 4].element;
            gameMap[next].element = -1;
            next += 4;
          }

          gameMap[next].element = gameMap[i].element;
          gameMap[i].element = -1;
        } else if (gameMap[next].element == gameMap[index].element) {
          gameMap[index].element += gameMap[next].element;
          gameMap[next].element = -1;
          gameMap[next].element = gameMap[index].element;
          gameMap[index].element = -1;
        }
      }
    }
    setState(() {});
  }
}

class Field {
  final int postion;
  int element;

  Field(this.postion, {this.element = -1});

  bool hasElement() {
    return element != -1;
  }
}
