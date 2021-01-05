import 'dart:convert';

import 'package:RickAndMortyApi/helpers/SearchHandler.dart';
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

  bool searching = false;

  void getCharactersByName(String name) {
    searchHandler.searchCharactersByName(name).then((value) {
      print("Hallo?");
      print(searchHandler.results.length);
      setState(() {
        searchHandler = searchHandler;
      });
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
                opacity: searching ? 0.5 : 1,
                child: CharactersWidget(
                  key: ObjectKey("characterList"),
                  firstCharacterId: firstCharacterId,
                )),
            if (searching)
              PositionedSearchResultList(
                key: ObjectKey("pSRL"),
                setCharacter: setCharacter,
                nameIdResults: searchHandler.results,
              ),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButtons(
          searching: searching,
          toggleSearching: toggleSearching,
          onSubmitted: getCharactersByName),
    );
  }

  void setCharacter(id) {
    setState(() {
      firstCharacterId = id;
    });
  }

  void toggleSearching() {
    setState(() {
      searching = !searching;
    });
  }
}
