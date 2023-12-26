

import 'package:admin/models/address_model.dart';
import 'package:admin/models/cart_model.dart';

class OrderModel {
  late String? paymentId;
  late String? paymentMethod;
  late String id;
  late String state;
  late double totalPrice;
  late String contactPersonName;
  late String contactPersonNumber;
  late AddressModel addressModel;
  late String time;
  List<CartModel> items=[];
  OrderModel(
      {
         this.paymentId,
        required this.paymentMethod,
        required this.id,
        required this.time,
        required this.state,
        required this.totalPrice,
        required this.contactPersonName,
        required this.addressModel,
        required this.contactPersonNumber,
        required this.items});

  OrderModel.fromJson(Map<String, dynamic> json) {
    paymentId=json['payment_id'];
    paymentMethod=json['payment_method'];
    id=json['id'];
    time = json['time'];
    state = json['state'];
    totalPrice = json['totalPrice'];
    addressModel = AddressModel.fromJson(json['addressModel']);
    contactPersonNumber = json['contact_person_number'];
    contactPersonName = json['contact_person_name'];
    json['items'].forEach((element){
      items.add(CartModel.fromJson(element));
    });
  }
  List<String> products=[];


  Map<String, dynamic> toJson() {
    List<Map<String,dynamic>> products=[];
    for (var element in items) {
      products.add(element.toJson());
    }

    return {
      'payment_id': paymentId,
      'payment_method': paymentMethod,
      'id':id,
      'time': time,
      'state': state,
      'totalPrice': totalPrice,
      'addressModel': addressModel.toJson(),
      'items': products,
      'contact_person_number': contactPersonNumber,
      'contact_person_name': contactPersonName,
    };
  }
}
