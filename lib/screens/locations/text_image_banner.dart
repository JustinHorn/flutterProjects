import 'package:flutter/material.dart';

import '../location_detail/image_banner.dart';

class TextOnImageBanner extends StatelessWidget {
  final String _assetPath;
  final double height;
  final String text;
  final void Function() onTap;

  TextOnImageBanner(this._assetPath, this.text,
      {this.height = 200.0, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.passthrough, children: [
      Container(
        constraints: BoxConstraints.expand(height: height),
        decoration: BoxDecoration(color: Colors.grey),
        child: Image.asset(
          _assetPath,
          fit: BoxFit.cover,
        ),
      ),
      Container(
          constraints: BoxConstraints.expand(height: height),
          alignment: Alignment.bottomLeft,
          child: GestureDetector(
              onTap: onTap,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0),
              ))),
    ]);
  }
}
