import 'dart:io';
import 'dart:math';

import 'package:admin/models/product_model.dart';
import 'package:admin/models/restaurant_model.dart';
import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/layout/views/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RestaurantController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


   bool isUpdating=false;
  final restaurantName= TextEditingController();
  final restaurantDescription= TextEditingController();
  final restaurantQuote=       TextEditingController();
  final restaurantSpeciality=  TextEditingController();
  final restaurantRatings=     TextEditingController();
  String restaurantUid = "";

  String generateUid(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    final codeUnits = List.generate(length, (index) {
      final index = rand.nextInt(chars.length);
      return chars.codeUnitAt(
          index); // return integer code point instead of character
    });

    return String.fromCharCodes(codeUnits);
  }

  String? restaurantValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }

    final regexRestaurantName = RegExp(r"^[a-zA-Z0-9 '’-]+$");
    if (!regexRestaurantName.hasMatch(value)) {
      return "Invalid characters in This field";
    }

    return null;
  }
  List<ProductModel> newProducts = [];

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

  File? restaurantImage;

  Future getRestaurantImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        restaurantImage=File(value.path);
        update();
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  String? restaurantImageUrl;

  Future uploadRestaurantImage() async {
    try {
      File? file=await compressImage(restaurantImage!);
      final uploadTask = FirebaseStorage.instance
          .ref()
          .child('restaurants/$restaurantUid.jpg')
          .putFile(file!);

      final uploadSnapshot = await uploadTask;
      final downloadUrl = await uploadSnapshot.ref.getDownloadURL();
      restaurantImageUrl = downloadUrl;
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> uploadProductImage(File productImage, String productId) async {
    String downloadUrl="";
    try {
      File? file=await compressImage(productImage);
      final uploadTask = FirebaseStorage.instance
          .ref()
          .child('products/$productId.jpg')
          .putFile(file!);
      final uploadTaskSnapshot = await uploadTask;
       downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint(e.toString());
      return downloadUrl;
    }
  }
  double rating = 2.5;

  void setRating(double rate) {
    rating = rate;
    update();
  }

  bool loading=false;

  Future<void> addRestaurant() async {
    HomeController homeController=Get.find<HomeController>();
    loading=true;
    update();
    Get.snackbar("Add","Adding your restaurant is currently in progress. Please wait.",colorText: Colors.green,
    );
    try {
      await uploadRestaurantImage();
      RestaurantModel restaurantModel = RestaurantModel(
          image: restaurantImageUrl!,
          quote: restaurantQuote.text,
          description: restaurantDescription.text,
          speciality: restaurantSpeciality.text,
          id: restaurantUid,
          name: restaurantName.text,
          stars: rating,
          ratings: int.parse(
              restaurantRatings.text.isEmpty ? "0" : restaurantRatings.text));
      await FirebaseFirestore.instance.collection("restaurants").doc(
          restaurantUid).set(restaurantModel.toJson());
      homeController.restaurants.add(restaurantModel);
      homeController.restaurants.sort((a, b) => b.stars.compareTo(a.stars),);
      homeController.productsPerRest.putIfAbsent(restaurantUid, () => {
        "foods":[],
        "beverages":[],
        "desserts":[],
      });

     for(int i=0;i<newProducts.length;i++){
       newProducts[i].img=await uploadProductImage(newProducts[i].fileImage!, newProducts[i].id);

       await FirebaseFirestore.instance.collection("restaurants").doc(
           restaurantUid).collection("products").doc(newProducts[i].id).set(newProducts[i].toJson());
       //locally
       if(newProducts[i].category!.toLowerCase()=="food"){
         homeController.productsPerRest[restaurantModel.id]!["foods"]!.add(newProducts[i]);
       }
       else if(newProducts[i].category!.toLowerCase()=="desserts"){
         homeController.productsPerRest[restaurantModel.id]!["desserts"]!.add(newProducts[i]);
       }
       else{
         homeController.productsPerRest[restaurantModel.id]!["beverages"]!.add(newProducts[i]);
       }
       homeController.products.add(newProducts[i]);
     }
      homeController.update();

    }catch(e){
      debugPrint(e.toString());
    }
    loading=false;
    update();
  }


  void addProd(List<ProductModel> list,ProductModel product){
    product.restId=restaurantUid;
    bool exist=false;
    int i=0;
    while(i<newProducts.length&&!exist){
      if(newProducts[i].id==product.id){
        exist=true;
      }
      else{
        i++;
      }
    }
    list.add(product);
    if(exist==false){
      newProducts.add(product);
    }
    else{
        newProducts[i]=product;
      }
    update();
  }
  void putProduct(ProductModel product){
    ProductModel? pos=foods.firstWhereOrNull((element) => element.id==product.id);
    if(pos==null){
      pos=desserts.firstWhereOrNull((element) => element.id==product.id);
      if(pos==null){
        beverages.removeWhere((element) => element.id==product.id);
      }
      else{
        desserts.removeWhere((element) => element.id==product.id);
      }
    }
    else{
      foods.removeWhere((element) => element.id==product.id);
    }
    switch(product.category){
      case 'food':
        addProd(foods,product);
        break;
      case 'desserts':
        addProd(desserts,product);
        break;
      case 'beverages':
        addProd(beverages,product);
        break;
    }
    update();
  }
  void checkAndUpdateLocally(ProductModel product){
    HomeController homeController=Get.find<HomeController>();
    int index= homeController.products.indexWhere((element) => element.id==product.id);
      switch(product.category){
        case 'food':
          if(homeController.productsPerRest[product.restId]!['foods']!.indexWhere((element) => element.id==product.id)==-1) {
            homeController.productsPerRest[product.restId]!['foods']!.add(product);
          }else{
            homeController.productsPerRest[product.restId]!['foods']![homeController.productsPerRest[product.restId]!['foods']!.indexWhere((element) => element.id==product.id)]=product;
          }
          break;
        case 'desserts':
          if(homeController.productsPerRest[product.restId]!['desserts']!.indexWhere((element) => element.id==product.id)==-1) {
            homeController.productsPerRest[product.restId]!['desserts']!.add(product);
          }else{
            homeController.productsPerRest[product.restId]!['desserts']![homeController.productsPerRest[product.restId]!['desserts']!.indexWhere((element) => element.id==product.id)]=product;
          }
          break;
        case 'beverages':
          if(homeController.productsPerRest[product.restId]!['beverages']!.indexWhere((element) => element.id==product.id)==-1) {
            homeController.productsPerRest[product.restId]!['beverages']!.add(product);
          }else{
            homeController.productsPerRest[product.restId]!['beverages']![homeController.productsPerRest[product.restId]!['beverages']!.indexWhere((element) => element.id==product.id)]=product;
          }
          break;
      }
      if(index==-1){
        homeController.products.add(product);
      }
      else{
        homeController.products[index]=product;
      }
      homeController.update();

  }
  Future<void> updateRestaurant() async {
    loading=true;
    update();
    Get.snackbar("Update","Updating your restaurant is currently in progress. Please wait.",colorText: Colors.green,);
    try {
      if(restaurantImage!=null) await uploadRestaurantImage();
      RestaurantModel restaurantModel = RestaurantModel(
          image:restaurantImage!=null? restaurantImageUrl!:restaurantNetImage!,
          quote: restaurantQuote.text,
          description: restaurantDescription.text,
          speciality: restaurantSpeciality.text,
          id: restaurantUid,
          name: restaurantName.text,
          stars: rating,
          ratings: int.parse(
              restaurantRatings.text.isEmpty ? "0" : restaurantRatings.text));
      await FirebaseFirestore.instance.collection("restaurants").doc(
          restaurantUid).set(restaurantModel.toJson());
      Get.find<HomeController>().restaurants[Get.find<HomeController>().restaurants.indexWhere((element) => element.id==restaurantModel.id)]=restaurantModel;
      Get.find<HomeController>().restaurants.sort((a, b) => b.stars.compareTo(a.stars),);
      Get.find<HomeController>().update();
      for(int i=0;i<newProducts.length;i++){
        if(newProducts[i].fileImage!=null) {
          newProducts[i].img=await uploadProductImage(newProducts[i].fileImage!, newProducts[i].id);
        }
        checkAndUpdateLocally(newProducts[i]);
        await FirebaseFirestore.instance.collection("restaurants").doc(
            restaurantUid).collection("products").doc(newProducts[i].id).set(newProducts[i].toJson());
      }
    }catch(e){
      debugPrint(e.toString());
    }
    isUpdating=false;
    loading=false;
    update();
  }





  Future removeProd(ProductModel productModel)async{
    if(isUpdating)await FirebaseFirestore.instance.collection("restaurants").doc(restaurantUid).collection("products").doc(productModel.id).delete();
    newProducts.removeWhere((element) => productModel.id==element.id);
    switch(productModel.category){
      case 'food':
        foods.removeWhere((element) => productModel.id==element.id);
        break;
      case 'desserts':
        desserts.removeWhere((element) => productModel.id==element.id);

        break;
      case 'beverages':
        beverages.removeWhere((element) => productModel.id==element.id);
        break;
    }
    update();
  }
  Future removeRestaurant()async{
    loading=true;
    update();
    await FirebaseFirestore.instance.collection("restaurants").doc(restaurantUid).collection("products").get().then((value) async{
      for (var element in value.docs) {


        await element.reference.delete();
      }
    },);
    await FirebaseFirestore.instance.collection("restaurants").doc(restaurantUid).delete();
    loading=false;
    update();
    Get.offAll(const HomeLayOutScreen());
    Get.snackbar("Delete", "Restaurant has been deleted successfully",colorText: Colors.green);
  }





  List<ProductModel> foods=[];
  List<ProductModel> beverages=[];
  List<ProductModel> desserts=[];
  String? restaurantNetImage;
  void autoFillRestaurant(RestaurantModel restaurantModel){
    restaurantUid=restaurantModel.id;
    restaurantName.text=restaurantModel.name;
    restaurantDescription.text=restaurantModel.description;
    restaurantQuote.text=restaurantModel.quote;
    restaurantSpeciality.text=restaurantModel.speciality;
    restaurantRatings.text=restaurantModel.ratings==null?"":restaurantModel.ratings.toString();
    restaurantNetImage=restaurantModel.image;
    rating=restaurantModel.stars;
    HomeController homeController=Get.find<HomeController>();
    foods=homeController.productsPerRest[restaurantModel.id]!['foods']??[];
    beverages=homeController.productsPerRest[restaurantModel.id]!['beverages']??[];
    desserts=homeController.productsPerRest[restaurantModel.id]!['desserts']??[];
  }
  void blankRestaurant(){
    restaurantImage=null;
    restaurantUid=generateUid(22);
    restaurantName.text="";
    restaurantDescription.text="";
    restaurantQuote.text="";
    restaurantSpeciality.text="";
    restaurantRatings.text="";
    restaurantNetImage=null;
    rating=2.5;
   foods=[];
   beverages=[];
   desserts=[];
  }

}