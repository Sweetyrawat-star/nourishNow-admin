
import 'package:admin/models/product_model.dart';

class CartModel {
  late int quantity;
  late String time;
  late ProductModel product;

  CartModel({
   required this.quantity,
   required this.time,
   required this.product
  });

  CartModel.fromJson(Map<String, dynamic> json) {

    quantity = json['quantity'];
    time = json['time'];
    product = ProductModel.fromJson(json['product']);
  }

  Map<String,dynamic> toJson(){
    return
      {

        "quantity":quantity,
        "time":time,
        "product":product.toJson(),
    };
  }
}