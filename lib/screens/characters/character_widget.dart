import 'package:RickAndMortyApi/models/character.dart';
import 'package:flutter/material.dart';

class CharacterWidget extends StatelessWidget {
  const CharacterWidget({
    Key key,
    @required this.character,
  }) : super(key: key);

  final Character character;

  @override
  Widget build(BuildContext context) {
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
  }
}
