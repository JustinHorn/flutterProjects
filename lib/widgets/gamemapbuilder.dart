import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/animations/tile_animations.dart';
import 'package:twentyfourtyeight/widgets/tile_widget.dart';

class GameMapBuilder extends StatelessWidget {
  final double fieldDistance = 7;

  final List<TileAnimation> tileAnimations;
  final AnimationController controller;

  const GameMapBuilder({Key key, this.tileAnimations, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width - 32;

    double fieldSize = (totalWidth - fieldDistance) / 4 - fieldDistance;
    List<Positioned> fields = List<Positioned>.generate(
        16,
        (index) => Positioned(
              top: (index / 4).floor() * (fieldSize + fieldDistance) +
                  fieldDistance,
              left: (index % 4) * (fieldSize + fieldDistance) + fieldDistance,
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
        getAnimatedTileBuilders(tileAnimations, fieldSize, fieldDistance);

    return Stack(
      children: [...fields, ...animatedBuilders],
    );
  }

  List<Widget> getAnimatedTileBuilders(tileAnimations, fieldSize, distance) {
    return tileAnimations
        .map((animation) => AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double left = calcPositionOfTile(
                    animation.x.value.floor(), fieldSize, distance);

                double top = calcPositionOfTile(
                    animation.y.value.floor(), fieldSize, distance);

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
  }

  double calcPositionOfTile(int position, double size, distance) {
    return position.toDouble() * (size + distance) + distance + size * 0.05;
  }
}
