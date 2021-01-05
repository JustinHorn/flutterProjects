import 'package:RickAndMortyApi/models/character.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CharacterWidget extends StatelessWidget {
  CharacterWidget({
    Key key,
    @required this.characterId,
  }) : super(key: key);

  final int characterId;

  Future character;

  Future<void> getSingleCharacter() async {
    String query = """query {
  character(id:${characterId}) {
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
    print("character ${character.name} has been fetched ");
    return character;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getSingleCharacter(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Characters is being fetched!");
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
                    Image.network(character.image),
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
