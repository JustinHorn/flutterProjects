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
