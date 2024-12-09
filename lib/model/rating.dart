import 'dart:convert';

List<Rating> ratingFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  double rating;
  String productId;

  Rating({
    required this.rating,
    required this.productId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json["rating"]?.toDouble(),
      productId: json["productId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "productId": productId,
  };
}