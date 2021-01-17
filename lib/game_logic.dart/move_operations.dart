import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

import 'field.dart';

class MoveOperator {
  List<Field> map;

  MoveOperator(List<Field> map) {
    this.map = List.empty(growable: true);
    map.forEach((element) {
      this.map.add(element);
    });
  }

  moveLeft() {
    for (int i = 0; i < 4; i++) {
      for (int j = 1; j < 4; j++) {
        int index = i * 4 + j;
        int nextLine = (i * 4 - 1);
        Function getNext = (int previous) => previous - 1;
        Function inBounds = (int index) => index > nextLine;

        moveElements(index, getNext, inBounds);
      }
    }
    return map;
  }

  moveRight() {
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j >= 0; j--) {
        int index = i * 4 + j;
        int nextLine = ((i + 1) * 4);
        Function getNext = (int previous) => previous + 1;
        Function inBounds = (int index) => index < nextLine;
        moveElements(index, getNext, inBounds);
      }
    }
    return map;
  }

  moveUp() {
    for (int i = 4; i < map.length; i++) {
      int index = i;
      Function getNext = (int previous) => previous - 4;
      Function inBounds = (int index) => index >= 0;
      moveElements(index, getNext, inBounds);
    }
    return map;
  }

  moveDown() {
    for (int i = map.length - 5; i >= 0; i--) {
      int index = i;
      Function getNext = (int previous) => previous + 4;
      Function inBounds = (int index) => index < map.length;
      moveElements(index, getNext, inBounds);
    }
    return map;
  }

  void moveElements(int index, Function getNext, Function inBounds) {
    if (map[index].hasTile()) {
      int next = getNext(index);
      if (!map[next].hasTile()) {
        int veryNext = getNext(next);
        while (inBounds(veryNext) && !map[veryNext].hasTile()) {
          next = veryNext;
          veryNext = getNext(veryNext);
        }

        if (inBounds(veryNext) &&
            map[veryNext].hasTile() &&
            map[index].tile == map[veryNext].tile &&
            !map[veryNext].tile.hasJustBeenMerged) {
          mergeElements(index, veryNext);
          next = veryNext;
        }

        moveElement(index, next);
      } else if (map[next].tile == map[index].tile) {
        mergeElements(index, next);
        moveElement(index, next);
      }
    }
  }

  mergeElements(int positionMover, int positionCollider) {
    if (map[positionMover].tile != map[positionCollider].tile) {
      throw new Exception(
          "Elements are not allowed to be merged because they are unequal!");
    }

    map[positionMover].tile =
        Tile.merge(map[positionMover].tile, map[positionCollider].tile);
    map[positionCollider].tile = null;
  }

  moveElement(int current, int next) {
    if (!map[current].hasTile()) {
      throw new Exception(
          "Expected to move an element, but no element was there");
    }

    map[next].tile = map[current].tile;
    map[current].tile = null;
  }

  bool canMove() {
    if (canMoveLeft()) return true;
    if (canMoveRight()) return true;
    if (canMoveUp()) return true;
    if (canMoveDown()) return true;
    return false;
  }

  bool canMoveLeft() {
    for (int i = 0; i < 4; i++) {
      for (int j = 1; j < 4; j++) {
        int index = i * 4 + j;
        int nextLine = (i * 4 - 1);
        Function getNext = (int previous) => previous - 1;
        Function inBounds = (int index) => index > nextLine;

        if (canMoveElements(index, getNext, inBounds)) return true;
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j >= 0; j--) {
        int index = i * 4 + j;
        int nextLine = ((i + 1) * 4);
        Function getNext = (int previous) => previous + 1;
        Function inBounds = (int index) => index < nextLine;

        if (canMoveElements(index, getNext, inBounds)) return true;
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int i = 4; i < map.length; i++) {
      int index = i;
      Function getNext = (int previous) => previous - 4;
      Function inBounds = (int index) => index >= 0;
      if (canMoveElements(index, getNext, inBounds)) return true;
    }
    return false;
  }

  bool canMoveDown() {
    for (int i = map.length - 5; i >= 0; i--) {
      int index = i;
      Function getNext = (int previous) => previous + 4;
      Function inBounds = (int index) => index < map.length;
      if (canMoveElements(index, getNext, inBounds)) return true;
    }
    return false;
  }

  bool canMoveElements(int index, Function getNext, Function inBounds) {
    if (map[index].hasTile()) {
      int next = getNext(index);
      if (!map[next].hasTile()) {
        return true;
      } else if (map[next].tile == map[index].tile) {
        return true;
      }
    }
    return false;
  }
}
