import 'dart:convert';

import 'package:RickAndMortyApi/service/SearchHandler.dart';
import 'package:RickAndMortyApi/shared/loading.dart';
import 'package:flutter/material.dart';

import './characters.dart';

import 'package:http/http.dart' as http;

import 'PositionedSearchResultList.dart';
import 'floatingactionbuttons.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SearchHandler searchHandler = SearchHandler();

  int firstCharacterId = 1;

  @override
  void initState() {
    super.initState();
  }

  bool searchMode = false;
  Future searchFuture;

  void getCharactersByName(String name) {
    setState(() {
      searchFuture = Future.delayed(const Duration(seconds: 2),
          () async => await searchHandler.searchCharactersByName(name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(children: [
            Opacity(
                opacity: searchMode ? 0.5 : 1,
                child: CharactersWidget(
                  key: ObjectKey("characterList"),
                  firstCharacterId: firstCharacterId,
                )),
            if ((searchFuture != null || searchHandler.results.length > 0) &&
                searchMode)
              FutureBuilder(
                  future: searchFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Loading();
                    } else {
                      return PositionedSearchResultList(
                        key: ObjectKey("pSRL"),
                        setCharacter: setCharacter,
                        nameIdResults: snapshot.data,
                      );
                    }
                  }),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButtons(
          searchMode: searchMode,
          toggleSearchMode: toggleSearchMode,
          onSubmitted: getCharactersByName),
    );
  }

  void setCharacter(id) {
    setState(() {
      firstCharacterId = id;
    });
  }

  void toggleSearchMode() {
    setState(() {
      searchMode = !searchMode;
    });
  }
}
