class Rating {
  final String critic;
  final String rating;

  Rating(this.critic, this.rating);

  Map<String, String> toMap() {
    return {
      "critic": critic,
      "rating": rating,
    };
  }

  static Rating fromMap(Map<String, dynamic> map) {
    return Rating(
      map["critic"],
      map["rating"],
    );
  }
}
