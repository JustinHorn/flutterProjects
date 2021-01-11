import 'dart:collection';

import 'package:RickAndMortyApi/models/character.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

HashMap<int, Character> characterMap = new HashMap();

Future<Character> getSingleCharacter(int characterId) async {
  if (characterMap.containsKey(characterId)) {
    return characterMap[characterId];
  }
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
  characterMap.putIfAbsent(characterId, () => character);
  return character;
}
