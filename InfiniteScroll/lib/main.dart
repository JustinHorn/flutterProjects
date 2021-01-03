import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import "dog_scroll.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageView(
        children: [Text("hi"), DogScrollPage(title: 'Dog Scroll Page')],
      ),
    );
  }
}
