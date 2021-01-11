import 'package:RickAndMortyApi/animator.dart';
import 'package:RickAndMortyApi/models/name_id.dart';
import 'package:flutter/material.dart';

class PositionedSearchResultList extends StatelessWidget {
  final List<NameId> nameIdResults;
  final Function setCharacter;

  const PositionedSearchResultList(
      {Key key, this.nameIdResults, this.setCharacter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.1,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: ListView.builder(
            itemCount: nameIdResults.length,
            itemBuilder: (context, position) {
              NameId nameId = nameIdResults[position];
              return Widgetanimator(
                child: FlatButton(
                    color: Color(0xffc3deca),
                    onPressed: () {
                      setCharacter(nameId.id);
                    },
                    child: Text("${nameId.id} ${nameId.name}")),
              );
            }),
      ),
    );
  }
}
