import 'package:RickAndMortyApi/models/character.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'character_widget.dart';

class CharactersWidget extends StatefulWidget {
  @override
  _CharactersWidgetState createState() => _CharactersWidgetState();
}

class _CharactersWidgetState extends State<CharactersWidget> {
  int characterIndex = 0;
  List<Character> characters = new List(0);
  // String nextPage = "https://rickandmortyapi.com/api/character";
  int nextPage = 1;

  @override
  void initState() {
    super.initState();
    getNextPage();
  }

  void getNextPage() {
    String query = """query {
  characters(page:${nextPage}) {
    results {
      id
       name
       image
      status      
      species
      type
      gender
      location {
        name 
      }
      origin {
        name
      }
      episode {
        name
      }
    }
  }
}""";

    http.post("https://rickandmortyapi.com/graphql",
        body: {"query": query}).then((response) {
      dynamic decodedJson = jsonDecode(response.body);
      dynamic cha = decodedJson["data"]["characters"]["results"];
      setState(() {
        nextPage++;
        characters = [
          ...characters,
          ...cha
              .map((cMap) => Character.fromJSON(cMap))
              .toList()
              .cast<Character>()
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(initialPage: characterIndex),
      onPageChanged: (x) {
        characterIndex = x;
        print(characterIndex);
        if (characterIndex == characters.length - 1) {
          getNextPage();
        }
      },
      children: (characters != null
          ? characters.map((c) => CharacterWidget(character: c)).toList()
          : [Text("Characters have not been loaded")]),
    );
  }
}
