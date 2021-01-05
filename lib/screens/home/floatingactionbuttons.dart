import 'package:flutter/material.dart';

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
