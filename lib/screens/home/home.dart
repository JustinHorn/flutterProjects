import 'dart:convert';

import 'package:flutter/material.dart';

import './characters.dart';

import 'package:http/http.dart' as http;

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
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView(
                    children: nameIdResults
                        .map((nameId) => FlatButton(
                            color: Color(0xffc3deca),
                            onPressed: () {
                              setState(() {
                                firstCharacterId = nameId.id;
                              });
                            },
                            child: Text("${nameId.id} ${nameId.name}")))
                        .toList(),
                  ),
                ),
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

  void toggleSearching() {
    setState(() {
      searching = !searching;
    });
  }
}

class FloatingActionButtons extends StatelessWidget {
  final bool searching;
  final Function toggleSearching;
  final Function onSubmitted;

  const FloatingActionButtons(
      {Key key, this.searching, this.toggleSearching, this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(""),
          if (searching)
            Container(
              padding: EdgeInsets.all(5),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextField(
                onSubmitted: onSubmitted,
                style: TextStyle(color: Colors.white),
              ),
            ),
          FloatingActionButton(
            onPressed: toggleSearching,
            child: Icon(Icons.search),
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class NameId {
  final String name;
  final int id;

  NameId(this.name, this.id);
}
