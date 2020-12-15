import 'dart:convert';

import 'package:Movie_Suggester/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:Movie_Suggester/models/rating.dart';

import 'package:Movie_Suggester/extensions.dart';

import "package:Movie_Suggester/widgets/movie.dart";

import 'package:Movie_Suggester/helpers.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pages = 2;

  List<Movie> movies = [Movie.EMPTY(), Movie.EMPTY()];

  UniqueRandomNumber unique = UniqueRandomNumber();

  @override
  void initState() {
    super.initState();
    getMovies([]).then((value) => setState(() {
          movies = value;
        }));
  }

  Future<List<Movie>> getMovies(List<Movie> start) async {
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final movieKeys = json
        .decode(manifestJson)
        .keys
        .where((String key) =>
            key.startsWith('assets/movieData') && key.endsWith(".json"))
        .map((x) => x.replaceAll("%20", " "))
        .toList();

    print("mkl" + movieKeys.length.toString());
    List<Movie> newMovies = [...start];

    for (int i = 0; i < pages; i++) {
      String jsonData = await rootBundle.loadString(
          movieKeys[unique.getUniqueRandomNumber(movieKeys.length)]);
      Map<String, dynamic> results = json.decode(jsonData);
      newMovies.add(Movie.fromMap(results));
    }
    return newMovies;
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
          child: PageView(
            controller: PageController(initialPage: pages - 2),
            onPageChanged: (int x) {
              if (x == pages - 1) {
                getMovies(movies).then((List<Movie> value) => setState(() {
                      movies = value;

                      pages = value.length;
                    }));
              }
            },
            children: movies
                .mapIndexed((m, i) => MovieWidget(key: ValueKey(i), movie: m))
                .toList(),
          ),
        ),
      ),
    );
  }
}
