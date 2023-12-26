
class RestaurantModel {
  late String id;
  int? ratings;
  late String description;
  late String quote;
  late double stars;
  late String name;
  late String speciality;
  // late List<Product> products;
  late String image;

  RestaurantModel(
      {required this.image,
        required this.quote,
      required this.description,
      required this.speciality,
      required this.id,
      required this.name,
      required this.stars,
      // required this.products,
      required this.ratings});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    quote = json['quote'];
    speciality = json['speciality'];
    ratings = json['ratings'];
    id = json['id'];
    stars = json['stars'].toDouble();
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "speciality": speciality,
      "name": name,
      "description": description,
      "stars": stars,
      "quote": quote,
      "image" :image,
      // "products" :products,
      "ratings" :ratings,
    };
  }
}
