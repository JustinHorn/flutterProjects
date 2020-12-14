import 'dart:convert';

import 'package:MovieApp/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:MovieApp/models/rating.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          title: Text(widget.title),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: FutureBuilder(
            initialData: Movie.EMPTY(),
            future: () async {
              String jsonData = await rootBundle
                  .loadString("assets/movieData/best/1917 (2020).json");
              Map<String, dynamic> results = json.decode(jsonData);

              return Movie.fromMap(results);
            }(),
            builder: (context, snapshot) {
              return MovieWidget(key: ValueKey(1), movie: snapshot.data);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class MovieWidget extends StatelessWidget {
  final Movie movie;

  const MovieWidget({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(movie.name),
          Image(
            image: AssetImage(movie.getImageAssetLocation()),
          ),
          Text(movie.description),
          RatingWidget(
            key: ValueKey("rW1"),
            ratings: movie.ratings,
          ),
          CategoryWidget(
            key: ValueKey("cW1"),
            categories: movie.categories,
          )
        ],
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final List<Rating> ratings;

  const RatingWidget({Key key, this.ratings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ratings
          .map((rating) => Text(rating.critic + " " + rating.rating))
          .toList(),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final List<String> categories;

  const CategoryWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: categories.map((x) => Text(x)).toList());
  }
}
