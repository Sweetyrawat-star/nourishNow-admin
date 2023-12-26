import 'dart:io';

class ProductModel {
   File? fileImage;
   String? category;
   String? restId;
   int? ratings;
   late double stars;
   late String id;
   late String name;
  String? restName;
  late String description;
  late double price;
  late String img;
  String? createdAt;
  late bool inDiscount;
  double? discount;
  ProductModel({
    this.fileImage,
    this.category,
    this.restName,
    this.restId,
    this.ratings,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stars,
    required this.img,
    this.createdAt,
    this.discount,
    required this.inDiscount
  });



  ProductModel.fromJson(Map<String, dynamic> json) {
    category=json['category'];
    id = json['id'];
    restName = json['restName'];
    restId = json['restId'];
    name = json['name'];
    description = json['description'];
    price = json['price'].toDouble();
    stars = json['stars'].toDouble();
    img = json['img'];
    createdAt = json['createdAt'];
    if (json['discount']==null) {
      discount = null;
    } else {
      discount = json['discount'].toDouble();
    }
    inDiscount = json['inDiscount'];
    ratings = json['ratings'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "img": img,
      "description": description,
      "stars": stars,
      "createdAt": DateTime.now().toString(),
      "discount" :discount,
      "inDiscount" :inDiscount,
      "ratings" :ratings,
      "category":category
      // "restId" :restId,
      // "restName": restName,
    };
  }
}
