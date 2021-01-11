import 'dart:collection';

import 'package:RickAndMortyApi/service/getSingleCharacter.dart';
import 'package:RickAndMortyApi/models/character.dart';
import 'package:RickAndMortyApi/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CharacterWidget extends StatelessWidget {
  final int characterId;

  final Future character;
  CharacterWidget({
    Key key,
    @required this.characterId,
  })  : character = getSingleCharacter(characterId),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: character,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }

          Character character = snapshot.data;
          return ListView(
            shrinkWrap: true,
            children: [
              if (character != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${character.name}',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 10)),
                        child: Image.network(character.image)),
                    Text(
                      '${character.status}, ${character.species}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    if (character.type != "")
                      Text(
                        '${character.type}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    Tooltip(
                      message: "Origin",
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${character.origin}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Location",
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${character.location}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                    Text(
                      "${character.episodes.length} Episodes:",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    ...character.episodes
                        .map((name) => Text(
                              '${name}',
                              style: Theme.of(context).textTheme.bodyText2,
                            ))
                        .toList()
                  ],
                )
            ],
          );
        });
  }
}
