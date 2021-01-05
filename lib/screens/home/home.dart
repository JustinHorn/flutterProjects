import 'dart:convert';

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
  List<NameId> nameIdResults = [];

  int firstCharacterId = 1;

  @override
  void initState() {
    super.initState();
  }

  bool searching = false;

  void getCharactersByName(String name) {
    String query = """query {
  characters(filter:{name:"${name}"}) {
    results {
      id
      name
    }
  }
}""";

    http.post("https://rickandmortyapi.com/graphql",
        body: {"query": query}).then((response) {
      dynamic characterResult = jsonDecode(response.body)["data"]["characters"];

      if (characterResult != null) {
        dynamic results = characterResult["results"];
        List<NameId> resultList = results
            .map((nameId) => NameId(nameId["name"], int.parse(nameId["id"])))
            .toList()
            .cast<NameId>();
        setState(() {
          nameIdResults = resultList;
        });
      } else {
        setState(() {
          nameIdResults = [];
        });
      }
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
                opacity: 1,
                child: CharactersWidget(
                  key: ObjectKey("characterList"),
                  firstCharacterId: firstCharacterId,
                )),
            if (searching)
              PositionedSearchResultList(
                key: ObjectKey("pSRL"),
                setCharacter: setCharacter,
                nameIdResults: nameIdResults,
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
