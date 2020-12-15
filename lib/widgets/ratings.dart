import 'package:flutter/material.dart';
import 'package:Movie_Suggester/models/rating.dart';

class RatingTable extends StatelessWidget {
  final List<Rating> ratings;

  const RatingTable({Key key, this.ratings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> critics = ratings
        .map((rating) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(rating.critic + "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ))
        .toList();
    List<Widget> results = ratings
        .map((rating) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(rating.rating + ""),
            ))
        .toList();
    return Table(
      border: TableBorder.all(color: Colors.black),
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      defaultColumnWidth: const MaxColumnWidth(
        const FixedColumnWidth(100.0),
        FractionColumnWidth(0.2),
      ),
      textBaseline: TextBaseline.alphabetic,
      children: [
        TableRow(
          children: critics,
        ),
        TableRow(
          children: results,
        )
      ],
    );
  }
}
