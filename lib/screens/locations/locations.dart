import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../app.dart';
import '../../models/location.dart';

import 'text_image_banner.dart';

class Locations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locations = Location.fetchAll();

    return Scaffold(
        backgroundColor: Colors.lightGreenAccent,
        appBar: AppBar(
          title: Text("Locations"),
        ),
        body: ListView(children: [
          Flex(
            direction: Axis.vertical,
            children: locations
                .map((location) => GestureDetector(
                      onTap: () => _onLocationTap(context, location.id),
                      child: TextOnImageBanner(
                        location.imagePath,
                        location.name,
                        height: 200,
                      ),
                    ))
                .toList(),
          )
        ]));
  }

  _onLocationTap(BuildContext context, int locationID) {
    Navigator.pushNamed(context, LocationDetailRoute,
        arguments: {"id": locationID});
  }
}
