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

  List<int> characterIds = [];

  PageController pageController;

  int firstCharacterMemo; // if this variable != widget.firstCharachterId then replace characters

  @override
  void initState() {
    super.initState();
    firstCharacterMemo = widget.firstCharacterId;
    pageController = PageController(
        initialPage: characterIndex,
        viewportFraction:
            0.99); // so the next and the previous is already being feched!

    initCharacters();
  }

  initCharacters() {
    characterIds = [];
    for (int i = 0; i < 10; i++) {
      if (widget.firstCharacterId + i >= 1) {
        characterIds.add(widget.firstCharacterId + i);
      }
    }
    for (int i = 0; i < 10; i++) {
      if (widget.firstCharacterId - 10 + i >= 1) {
        characterIds.add(widget.firstCharacterId - 10 + i);
      }
    }
    characterIds.sort((a, b) => a - b);
  }

  void paginateCharacters(int x) {
    characterIndex = x;
    if (characterIndex == characterIds.length - 1) {
      for (int i = 0; i < 10; i++) {
        if (characterIds.last + i >= 1) {
          characterIds.add(characterIds.last + i);
        }
      }
      setState(() {});
    } else if (characterIndex == 0 && characterIds.first != 1) {
      for (int i = 0; i < 10; i++) {
        if (characterIds.last + i - 10 >= 1) {
          characterIds.add(characterIds.last - 10 + i);
        }
        characterIds.sort((a, b) => a - b);
      }
      setState(() {});
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
      children: (characterIds.length > 0
          ? characterIds
              .map((id) => CharacterWidget(
                    characterId: id,
                    key: ObjectKey(id),
                  ))
              .toList()
          : [Text("Characters have not been loaded")]),
    );
  }
}
