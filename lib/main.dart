import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

/*
Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.count(
                  primary: true,
                  padding: EdgeInsets.all(8.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  crossAxisCount: 4,
                  children: List<int>.generate(16, (i) => i + 1)
                      .map((index) => Container(
                            color: Colors.brown,
                            child: Text("$index"),
                          ))
                      .toList(),
                ),
              ),
            ),
*/
