import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DogScrollPage extends StatefulWidget {
  DogScrollPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DogScrollPage createState() => _DogScrollPage();
}

class _DogScrollPage extends State<DogScrollPage> {
  List<String> dogImages = [];
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFive();

    _scrollController.addListener(() {
      print(_scrollController.position.pixels);
      if (_scrollController.position.pixels + 10 >=
          _scrollController.position.maxScrollExtent) {
        // if we are at the bottom
        fetchFive();
      }
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: dogImages.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            constraints: BoxConstraints.tightFor(height: 150),
            child: Image.network(
              dogImages[index],
              fit: BoxFit.fitWidth,
            ),
          );
        },
      ),
    );
  }

  fecthImage() async {
    final response = await http.get("https://dog.ceo/api/breeds/image/random");
    if (response.statusCode == 200) {
      setState(() {
        dogImages.add(json.decode(response.body)['message']);
      });
    } else {
      throw Exception("Failed to load Images");
    }
  }

  fetchFive() {
    for (int i = 0; i < 5; i++) {
      fecthImage();
    }
  }
}
