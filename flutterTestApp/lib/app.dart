import 'package:app/screens/location_detail/location_detail.dart';
import 'package:flutter/material.dart';
import 'screens/locations/locations.dart';
import 'screens/location_detail/location_detail.dart';

import 'style.dart';

const LocationsRoute = '/';
const LocationDetailRoute = '/location_detail';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _routes(),
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(textTheme: TextTheme(bodyText1: AppBarTextStyle)),
        textTheme:
            TextTheme(headline1: TitleTextStyle, bodyText1: BodyTextStyle),
      ),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
      switch (settings.name) {
        case LocationsRoute:
          screen = Locations();
          break;
        case LocationDetailRoute:
          screen = LocationDetail(arguments['id']);
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
