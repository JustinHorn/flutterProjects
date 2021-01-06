import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Firebase Error");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Authenticate();
            }
            return Text("loading");
          }),
    );
  }
}
