import 'package:flutter/material.dart';

class SearchTextInput extends StatelessWidget {
  const SearchTextInput({
    Key key,
    @required this.onSubmitted,
  }) : super(key: key);

  final Function onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 200.0,
      decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: TextField(
        textInputAction: TextInputAction.search,
        textAlign: TextAlign.center,
        decoration: InputDecoration.collapsed(hintText: "Enter Phrase"),
        onSubmitted: onSubmitted,
        style: TextStyle(color: Colors.white, fontSize: 22.0),
      ),
    );
  }
}
