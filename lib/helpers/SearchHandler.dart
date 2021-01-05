import 'dart:convert';

import 'package:http/http.dart' as http;

class NameId {
  final String name;
  final int id;

  NameId(this.name, this.id);
}

class SearchHandler {
  List<NameId> results = [];

  Future<void> searchCharactersByName(String name) async {
    String query = """query {
  characters(filter:{name:"${name}"}) {
    results {
      id
      name
    }
  }
}""";

    http.Response response = await http
        .post("https://rickandmortyapi.com/graphql", body: {"query": query});
    dynamic characterResult = jsonDecode(response.body)["data"]["characters"];

    if (characterResult != null) {
      dynamic queryResults = characterResult["results"];
      List<NameId> resultList = queryResults
          .map((nameId) => NameId(nameId["name"], int.parse(nameId["id"])))
          .toList()
          .cast<NameId>();

      results = resultList;
    } else {
      results = [];
    }
  }
}
