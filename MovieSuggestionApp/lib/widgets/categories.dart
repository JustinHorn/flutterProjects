import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;

  const CategoryList({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: categories
            .map((x) => Category(
                  name: x,
                ))
            .toList());
  }
}

class Category extends StatelessWidget {
  final String name;

  const Category({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(name, style: TextStyle(color: Colors.white)));
  }
}
