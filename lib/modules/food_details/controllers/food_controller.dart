import 'dart:io';
import 'dart:math';

import 'package:admin/models/product_model.dart';
import 'package:admin/modules/food_details/views/food_details.dart';
import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/layout/views/layout.dart';
import 'package:admin/modules/restaurant_details/controllers/restaurant_controller.dart';
import 'package:admin/modules/restaurant_details/views/add_new_restaurant.dart';
import 'package:admin/modules/restaurant_details/views/restaurant_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class FoodController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    id=generateUid(22);
  }

  final productName = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();
  final productRatings = TextEditingController();

  String generateUid(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    final codeUnits = List.generate(length, (index) {
      final index = rand.nextInt(chars.length);
      return chars.codeUnitAt(index); // return integer code point instead of character
    });

    return String.fromCharCodes(codeUnits);
  }

  String? productValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }

    final regexProductName = RegExp(r"^[a-zA-Z0-9 '’-]+$");
    if (!regexProductName.hasMatch(value)) {
      return "Invalid characters in This field";
    }

    return null;
  }
  String id="";

  String? priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Price cannot be empty";
    }
    final regexPrice = RegExp(r"^(?!,)\d{1,4}(\.\d{1,2})?$");
    if (!regexPrice.hasMatch(value)) {
      return "Price is invalid";
    }

    return null;
  }
  Future<File?> compressImage(File file) async {
    try {
      final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
      String targetPath = "${appDocumentsDir.path}/compressed_image.jpg";
      File? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 70,
      );
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
  File? productImage;

  Future getProductImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        productImage =File(value.path);
        update();
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  double rating = 2.5;

  void setRating(double rate) {
    rating = rate;
    update();
  }

  //drop down button
  String? dropDownValue = "food";
  List<String> dropDownChoices = ["food", "desserts", "beverages"];

  void onDropDownChanged(String? value) {
    dropDownValue = value;
    update();
  }

  //discount slider
  double discount = 0;

  void onSliderChanged(double value) {
    discount = value;
    update();
  }

bool loading=false;

  Future addProduct() async{
    debugPrint('hey');
    loading=true;
    update();
    RestaurantController restaurantController= Get.find<RestaurantController>();
    ProductModel product = ProductModel(
      restId: restId,
        fileImage: productImage,
        category: dropDownValue!,
        id: id,
        ratings:productRatings.text.isNotEmpty? int.parse(productRatings.text):null,
        name: productName.text,
        description: productDescription.text,
        price: double.parse(productPrice.text),
        stars: rating,
        img:productImageUrl??"",
        inDiscount:discount>0,
        discount:discount>0?(double.parse(productPrice.text)-double.parse(productPrice.text)*discount/100):null
    );
    restaurantController.putProduct(product);
    // Get.find<HomeController>().removeUpdateProd(product, restI;d,isDelete: false);
    loading=false;
    update();
    Get.back();
    restaurantController.update();
  }

  Future uploadProductImage() async {
    try {
      File? file = await compressImage(productImage!);
      final value = await FirebaseStorage.instance
          .ref()
          .child('products/$id')
          .putFile(file!);
      productImageUrl = await value.ref.getDownloadURL();
      update();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future updateProduct()async{

    loading=true;
    update();
    if(fromProduct)
      {if (productImage!=null) await uploadProductImage();
        ProductModel product = ProductModel(
          restId: restId,
            fileImage: productImage,
            category: dropDownValue!,
            id: id,
            ratings:productRatings.text.isNotEmpty? int.parse(productRatings.text):null,
            name: productName.text,
            description: productDescription.text,
            price: double.parse(productPrice.text),
            stars: rating,
            img:productImageUrl!,
            inDiscount:discount>0,
            discount:discount>0?(double.parse(productPrice.text)-double.parse(productPrice.text)*discount/100):null
        );
      await FirebaseFirestore.instance.collection("restaurants").doc(restId).collection("products").doc(product.id).update(product.toJson()).then((value) {

      }).catchError((e){
        debugPrint(e.toString());
      });
      Get.find<HomeController>().removeUpdateProd(product, restId,isDelete: false);
      loading=false;
      update();
      Get.offAll(const HomeLayOutScreen());
      Get.to(RestaurantDetailScreen(restaurantModel:  Get.find<HomeController>().restaurants.firstWhere((element) => element.id==restId)));
      Get.to(FoodDetailScreen(productModel: product));

      }
  }

  Future removeProd(ProductModel productModel)async{
    HomeController homeController=Get.find<HomeController>();
    if(!Get.isRegistered<RestaurantController>()) {
      Get.lazyPut(() => RestaurantController(),fenix: true);
      Get.find<RestaurantController>().isUpdating=true;
    }
    RestaurantController  restaurantController= Get.find<RestaurantController>();
    loading=true;
    update;
    homeController.removeUpdateProd(productModel, restId,isDelete: true);
    if(fromProduct){
      await FirebaseFirestore.instance.collection("restaurants").doc(productModel.restId!).collection("products").doc(productModel.id).delete();
    }
    else
      {
        await Get.find<RestaurantController>().removeProd(productModel);
      }
    loading=false;
    update();
    if(!restaurantController.isUpdating){
      restaurantController.update();
      Get.back();
    }
    else{
      Get.offAll(AddEditRestaurant(edit: true,restaurantModel: homeController.restaurants.firstWhere((element) => element.id==productModel.restId),));
      switch(productModel.category){
        case 'food':
          Get.find<RestaurantController>().foods.removeWhere((element) => productModel.id==element.id);
          break;
        case 'desserts':
          Get.find<RestaurantController>().desserts.removeWhere((element) => productModel.id==element.id);

          break;
        case 'beverages':
          Get.find<RestaurantController>().beverages.removeWhere((element) => productModel.id==element.id);
          break;


      }
      restaurantController.update();
    }



    Get.snackbar("Delete", "Product has been deleted successfully",colorText: Colors.green);
  }


  bool fromProduct=false;
  String? restId;
  String? productImageUrl;
  // to fill the form with selected product
  void autoFillForm(ProductModel productModel, {File? prodImage}){
    restId=productModel.restId;
    id=productModel.id;
    productName.text=productModel.name;
    productDescription.text=productModel.description;
    productPrice.text=productModel.price.toString();
    productRatings.text=productModel.ratings!=null?productModel.ratings.toString():"";
    dropDownValue=productModel.category!;
    rating=productModel.stars;
    discount=productModel.inDiscount?(productModel.price-productModel.discount!)*100/productModel.price:0;
    productImage=prodImage??productModel.fileImage;
    productImageUrl=productModel.img;
    update();
  }
}