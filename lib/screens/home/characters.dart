import 'package:RickAndMortyApi/models/character.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'character_widget.dart';

class CharactersWidget extends StatefulWidget {
  final int firstCharacterId;

  const CharactersWidget({Key key, this.firstCharacterId = 1})
      : super(key: key);

  @override
  _CharactersWidgetState createState() => _CharactersWidgetState();
}

class _CharactersWidgetState extends State<CharactersWidget> {
  int characterIndex = 0;

  List<Character> singleCharacters = new List(0);

  @override
  void initState() {
    super.initState();

    add10Characters(1);
  }

  add10Characters(int idC1) {
    int firstCharacter = idC1;
    List<Future<void>> futures = [];
    for (int i = 0; i < 10; i++) {
      if (firstCharacter + i >= 1) {
        futures.add(getSingleCharacter(firstCharacter + i));
      }
    }
    Future.wait(futures).then((r) {
      singleCharacters.sort((a, b) => a.id - b.id);
      setState(() {
        singleCharacters = singleCharacters;
      });
    });
  }

  Future<void> getSingleCharacter(int id) async {
    print("hallo?!");
    String query = """query {
  character(id:${id}) {
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
}""";

    http.Response response = await http
        .post("https://rickandmortyapi.com/graphql", body: {"query": query});

    Character character =
        Character.fromJSON(jsonDecode(response.body)["data"]["character"]);
    print("character.name:");

    print(character.name);
    singleCharacters = [...singleCharacters, character];
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(initialPage: characterIndex),
      onPageChanged: (x) {
        characterIndex = x;
        print(characterIndex);
        if (characterIndex == singleCharacters.length - 1) {
          add10Characters(singleCharacters.last.id + 1);
        }
      },
      children: (singleCharacters.length > 0
          ? singleCharacters.map((c) => CharacterWidget(character: c)).toList()
          : [Text("Characters have not been loaded")]),
    );
  }
}
