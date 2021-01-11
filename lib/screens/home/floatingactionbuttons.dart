import 'package:RickAndMortyApi/animator.dart';
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
          if (searchMode)
            Widgetanimator(
              child: Container(
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
            ),
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
