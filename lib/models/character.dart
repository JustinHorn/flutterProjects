class Character {
  final int id;
  final String image;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String origin;
  final String location;
  final List<String> episodes;

  Character(
    this.id,
    this.image,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.origin,
    this.location,
    this.episodes,
  ) {
// hi
  }

  factory Character.fromJSON(Map<String, dynamic> json) {
    return Character(
      int.parse(json["id"]),
      json["image"],
      json["name"],
      json["status"],
      json["species"],
      json["type"],
      json["gender"],
      json["origin"]["name"],
      json["location"]["name"],
      json["episode"].map((x) => x["name"]).toList().cast<String>(),
    );
  }
}

class NameUrl {
  final String name;
  final String url;

  NameUrl(this.name, this.url);

  factory NameUrl.fromJSON(Map<String, dynamic> json) {
    return NameUrl(json["name"], json["url"]);
  }
}

class CharacterLocation extends NameUrl {
  CharacterLocation(String name, String url) : super(name, url);

  factory CharacterLocation.fromJSON(Map<String, dynamic> json) {
    return CharacterLocation(json["name"], json["url"]);
  }
}

class CharacterOrigin extends NameUrl {
  CharacterOrigin(String name, String url) : super(name, url);

  factory CharacterOrigin.fromJSON(Map<String, dynamic> json) {
    return CharacterOrigin(json["name"], json["url"]);
  }
}
