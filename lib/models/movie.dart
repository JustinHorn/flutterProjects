import 'package:MovieApp/models/rating.dart';

enum Status { best, unknown, underrated }

extension on Status {
  get name {
    return this.toString().split(".")[1];
  }
}

Status getStatusByName(String name) {
  List<Status> values = Status.values;
  for (int i = 0; i < values.length; i++) {
    if (values[i].name == name) {
      return values[i];
    }
  }
  throw Exception("Status with name ${name} not found!");
}

class Movie {
  final String name;
  final Status status;
  final String description;
  final List<Rating> ratings;
  final List<String> categories;

  Movie(
    this.name,
    this.status,
    this.description,
    this.ratings,
    this.categories,
  );

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "page": status.name,
      "description": description,
      "ratings": ratings.map((x) => x.toMap()).toList(),
      "categories": categories,
    };
  }

  static Movie fromMap(Map<String, dynamic> map) {
    List<Rating> ratings = List<Rating>.from(
        map["ratings"].map((x) => Rating.fromMap(x)).toList());
    return Movie(
      map["name"],
      getStatusByName(map["page"]),
      map["description"].replaceAll("\\n", "").trim(),
      ratings,
      List<String>.from(map["categories"]),
    );
  }

  static Movie EMPTY() {
    return Movie.fromMap({
      "name": "EmPtY",
      "page": "best",
      "description": "",
      "ratings": [
        {"critic": "", "rating": ""}
      ],
      "categories": []
    });
  }

  String getImageAssetLocation() {
    return "assets/movieImages/" + status.name + "/" + name + ".jpeg";
  }
}
