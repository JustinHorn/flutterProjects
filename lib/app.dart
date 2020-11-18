import 'package:flutter/material.dart';
import 'location_detail/location_detail.dart';

import 'style.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationDetail(),
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(textTheme: TextTheme(bodyText1: AppBarTextStyle)),
        textTheme:
            TextTheme(headline1: TitleTextStyle, bodyText1: BodyTextStyle),
      ),
    );
  }
}
