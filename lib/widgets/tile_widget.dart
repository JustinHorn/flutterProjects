import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';

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
          color: numTileColor[value],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getNumTileFigure(size)[value],
              ),
              Text(
                value.toString(),
                style: TextStyle(color: numTextColor[value]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Map<int, List<Widget>> getNumTileFigure(double size) {
  Map<int, List<Widget>> numTielFigure = {
    2: [BlackPawn(size: size * 0.3)],
    4: [BlackPawn(size: size * 0.3), BlackPawn(size: size * 0.3)],
    8: [
      WhitePawn(size: size * 0.3),
      WhitePawn(size: size * 0.3),
      WhitePawn(size: size * 0.3)
    ],
    16: [WhiteKnight(size: size * 0.4)],
    32: [WhiteBishop(size: size * 0.4)],
    64: [WhitePawn(size: size * 0.3), WhiteBishop(size: size * 0.4)],
    128: [WhiteRook(size: size * 0.45)],
    256: [WhitePawn(size: size * 0.3), WhiteRook(size: size * 0.45)],
    512: [
      WhitePawn(size: size * 0.3),
      WhitePawn(size: size * 0.3),
      WhiteRook(size: 0.45)
    ],
    1024: [WhiteQueen(size: size * 0.5)],
    2048: [WhiteKing(size: size * 0.8)],
  };

  return numTielFigure;
}

const Color lightBrown = Color.fromARGB(255, 205, 193, 180);
const Color darkBrown = Color.fromARGB(255, 187, 173, 160);
const Color orange = Color.fromARGB(255, 245, 149, 99);
const Color tan = Color.fromARGB(255, 238, 228, 218);
const Color numColor = Color.fromARGB(255, 119, 110, 101);
const Color greyText = Color.fromARGB(255, 119, 110, 101);

const Map<int, Color> numTileColor = {
  2: tan,
  4: tan,
  8: Color.fromARGB(255, 242, 177, 121),
  16: Color.fromARGB(255, 245, 149, 99),
  32: Color.fromARGB(255, 246, 124, 95),
  64: const Color.fromARGB(255, 246, 95, 64),
  128: const Color.fromARGB(255, 235, 208, 117),
  256: const Color.fromARGB(255, 237, 203, 103),
  512: const Color.fromARGB(255, 236, 201, 85),
  1024: const Color.fromARGB(255, 229, 194, 90),
  2048: const Color.fromARGB(255, 232, 192, 70),
};

const Map<int, Color> numTextColor = {
  2: greyText,
  4: greyText,
  8: Colors.white,
  16: Colors.white,
  32: Colors.white,
  64: Colors.white,
  128: Colors.white,
  256: Colors.white,
  512: Colors.white,
  1024: Colors.white,
  2048: Colors.white,
};
