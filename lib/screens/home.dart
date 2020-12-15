import 'dart:convert';

import 'package:MovieApp/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:MovieApp/models/rating.dart';

import 'package:MovieApp/extensions.dart';

import "package:MovieApp/widgets/movie.dart";

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 2;

  void incrementPage() {
    setState(() {
      page++;
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
            initialData: [Movie.EMPTY()],
            future: () async {
              final manifestJson = await DefaultAssetBundle.of(context)
                  .loadString('AssetManifest.json');
              final movieKeys = json
                  .decode(manifestJson)
                  .keys
                  .where((String key) =>
                      key.startsWith('assets/movieData') &&
                      key.endsWith(".json"))
                  .map((x) => x.replaceAll("%20", " "))
                  .toList();

              List<Movie> movies = [];

              for (int i = 0; i < page; i++) {
                String jsonData = await rootBundle.loadString(movieKeys[i]);
                Map<String, dynamic> results = json.decode(jsonData);
                movies.add(Movie.fromMap(results));
              }

              return movies;
            }(),
            builder: (context, snapshot) {
              List<Movie> movies = snapshot.data;
              return PageView(
                controller: PageController(initialPage: page - 2),
                onPageChanged: (int x) {
                  if (x == page - 1) incrementPage();
                },
                children: movies
                    .mapIndexed(
                        (m, i) => MovieWidget(key: ValueKey(i), movie: m))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
