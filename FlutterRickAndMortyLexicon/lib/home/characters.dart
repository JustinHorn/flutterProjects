import 'dart:math';

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
    add10IdsSorted(widget.firstCharacterId);
    add10IdsSorted(widget.firstCharacterId - 10);

    characterIds.sort((a, b) => a - b);
  }

  add10IdsSorted(int startValue) {
    for (int i = 0; i < 10; i++) {
      if (startValue + i >= 1) {
        characterIds.add(startValue + i);
      }
    }
    characterIds.sort((a, b) => a - b);
  }

  void paginateCharacters(int x) {
    characterIndex = x;
    if (characterIndex == characterIds.length - 1) {
      add10IdsSorted(characterIds.last + 1);

      setState(() {});
    } else if (characterIndex == 0 && characterIds.first != 1) {
      pageController.jumpToPage(min(characterIds.first, 10));
      add10IdsSorted(characterIds.first - 10);

      setState(() {});
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (firstCharacterMemo != widget.firstCharacterId) {
      firstCharacterMemo = widget.firstCharacterId;

      initCharacters();
      pageController.jumpToPage(min(widget.firstCharacterId, 10));
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
