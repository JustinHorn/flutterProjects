import 'package:RickAndMortyApi/animator.dart';
import 'package:RickAndMortyApi/home/search_text_input.dart';
import 'package:flutter/material.dart';

class FloatingActionButtons extends StatelessWidget {
  final bool searchMode;
  final Function toggleSearchMode;
  final Function onSubmitted;

  const FloatingActionButtons(
      {Key key, this.searchMode, this.toggleSearchMode, this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(""),
          FloatingActionButton(
            onPressed: toggleSearchMode,
            child: Icon(Icons.search),
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
