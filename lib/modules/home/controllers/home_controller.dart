import 'package:admin/models/product_model.dart';
import 'package:admin/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class HomeController extends GetxController{

  @override
  void onInit() async {
    super.onInit();
    await getRestaurants();
    getAllProducts();
    listenForRestaurantChanges();
  }

  List<RestaurantModel> restaurants = [];
  List<ProductModel> products = [];

  Map<String,Map<String,List<ProductModel>>> productsPerRest={};

  bool loading=false;

  void listenForRestaurantChanges() {
    FirebaseFirestore.instance.collection('restaurants').snapshots().listen((event) {
      for (var change in event.docChanges) {
        if (change.type == DocumentChangeType.removed) {
          getRestaurants();
        }
      }
    });
  }


  Future<void> getRestaurants() async{
    loading=true;
    update();
    CollectionReference<Map<String, dynamic>> restCollection =
    FirebaseFirestore.instance.collection("restaurants");
    await restCollection.orderBy('stars', descending: true).get().then((doc) {
      restaurants = [];
      for (var element in doc.docs) {
        Map<String, dynamic> temp = element.data();
        temp.putIfAbsent('id', () => element.id);
        productsPerRest.putIfAbsent(element.id, () => {
          "foods":[],
          "beverages":[],
          "desserts":[],
        });
        restaurants.add(RestaurantModel.fromJson(temp));

      }
      update();
    }).catchError((error) {
      debugPrint(error.toString());
    });
    loading=false;
    update();
  }

  Future<void> getAllProducts()async {
    products = [];
    loading=true;
    update();
    await FirebaseFirestore.instance.collectionGroup('products').orderBy("stars",descending: true).get().then((value) {
      for (var item in value.docs) {
        Map<String, dynamic> temp = item.data();
        temp.putIfAbsent('restId', () => restaurants.firstWhere((element) => item.reference.parent.parent!.id==element.id).id);
        temp.putIfAbsent('restName', () => restaurants.firstWhere((element) => item.reference.parent.parent!.id==element.id).name);
        temp.remove('id');
        temp.putIfAbsent('id', () => item.id);
        products.add(ProductModel.fromJson(temp));
                if(item["category"]=="food"){
                  //add food items
                  productsPerRest.update(temp['restId'], (value) {
                    value['foods']!.add(ProductModel.fromJson(temp));
                    return value;
                  } );

                }
                else if(item["category"]=="beverages"){
                  //add beverages items
                  productsPerRest.update(temp['restId'], (value) {
                    value['beverages']!.add(ProductModel.fromJson(temp));
                    return value;
                  } );
                }
                else{
                  //add desserts items
                  productsPerRest.update(temp['restId'], (value) {
                    value['desserts']!.add(ProductModel.fromJson(temp));
                    return value;
                  } );
                }
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });
    loading=false;
    update();
  }
  // Search List
  List<RestaurantModel> searchedRestaurants=[];
  List<ProductModel> searchedProducts=[];

  void search(List<dynamic> list,String searchedItem){
    if(searchedItem.isNotEmpty){
      if(list is List<ProductModel>){
        searchedProducts=list.where((product) => product.name.toLowerCase().contains(searchedItem.toLowerCase())).toList();
      }
      else{
        searchedRestaurants=(list as List<RestaurantModel>).where((restaurant) => restaurant.name.toLowerCase().contains(searchedItem.toLowerCase())).toList();
      }
    }
    else{
      searchedProducts=[];
      searchedRestaurants=[];
    }
    update();
  }

  TextEditingController searchController=TextEditingController();

void removeUpdateProd(ProductModel productModel,String? restID,{bool isDelete=false}){
  if(products.firstWhereOrNull((element) => element.id==productModel.id)!=null){
    if(isDelete) {
      if (productModel.category!.toLowerCase() == "food") {
        productsPerRest[restID]!["foods"]!.removeWhere((element) => element.id==productModel.id);
      }
      else if(productModel.category!.toLowerCase() == "desserts"){
        productsPerRest[restID]!["desserts"]!.removeWhere((element) => element.id==productModel.id);
      }
      else{
        productsPerRest[restID]!["beverages"]!.removeWhere((element) => element.id==productModel.id);
      }
      products.removeWhere((element) => element.id==productModel.id);
    }
    else{
      ProductModel? pos=productsPerRest[restID]!['foods']!.firstWhereOrNull((element) => element.id==productModel.id);
      if(pos==null){
        pos=productsPerRest[restID]!['desserts']!.firstWhereOrNull((element) => element.id==productModel.id);
        if(pos==null){
          productsPerRest[restID]!['beverages']!.removeWhere((element) => element.id==productModel.id);
        }
        else{
          productsPerRest[restID]!['desserts']!.removeWhere((element) => element.id==productModel.id);
        }
      }

      else{
        productsPerRest[restID]!['foods']!.removeWhere((element) => element.id==productModel.id);
      }

      if (productModel.category!.toLowerCase() == "food") {
        productsPerRest[restID]!["foods"]!.add(productModel);
      }
      else if(productModel.category!.toLowerCase() == "desserts"){
        productsPerRest[restID]!["desserts"]!.add(productModel);
      }
      else{
        productsPerRest[restID]!["beverages"]!.add(productModel);
      }
      products[products.indexWhere((element) => element.id==productModel.id)]=productModel;
    }
    update();
  }


}

}