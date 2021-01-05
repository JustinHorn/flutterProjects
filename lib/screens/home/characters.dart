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

  List<Character> characters = [];

  PageController pageController;

  int firstCharacterMemo; // if this variable != widget.firstCharachterId then replace characters

  @override
  void initState() {
    super.initState();
    firstCharacterMemo = widget.firstCharacterId;
    pageController = PageController(initialPage: characterIndex);

    initCharacters();
  }

  initCharacters() {
    characters = [];
    Future future = add10Characters(widget.firstCharacterId);

    Future future2 = add10Characters(widget.firstCharacterId - 10);

    Future.wait([future, future2]).then((value) {
      int index = characters
          .indexWhere((element) => element.id == widget.firstCharacterId);
      pageController.jumpToPage(index);
    });
  }

  Future<void> add10Characters(int idC1) async {
    int firstCharacter = idC1;
    List<Future<void>> futures = [];
    for (int i = 0; i < 10; i++) {
      if (firstCharacter + i >= 1) {
        futures.add(getSingleCharacter(firstCharacter + i));
      }
    }
    await Future.wait(futures);
    characters.sort((a, b) => a.id - b.id);
    setState(() {
      characters = characters;
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

    characters = [...characters, character];
  }

  void paginateCharacters(int x) {
    characterIndex = x;
    if (characterIndex == characters.length - 1) {
      add10Characters(characters.last.id + 1);
    } else if (characterIndex == 0 && characters.first.id != 1) {
      add10Characters(characters.first.id - 10).then((void x) {
        characterIndex += 10;
        pageController.jumpToPage(characterIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (firstCharacterMemo != widget.firstCharacterId) {
      firstCharacterMemo = widget.firstCharacterId;

      initCharacters();
    }

    return PageView(
      controller: pageController,
      onPageChanged: paginateCharacters,
      children: (characters.length > 0
          ? characters.map((c) => CharacterWidget(character: c)).toList()
          : [Text("Characters have not been loaded")]),
    );
  }
}
