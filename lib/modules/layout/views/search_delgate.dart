import 'package:admin/models/product_model.dart';
import 'package:admin/models/restaurant_model.dart';
import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/layout/views/widgets.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomSearchDelegate extends SearchDelegate{

  List<ProductModel> searchProducts=Get.find<HomeController>().products;
  List<RestaurantModel> searchRestaurants=Get.find<HomeController>().restaurants;



  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query="";
      }, icon: Icon(Icons.clear,color: AppColors.mainColor,)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: Icon(Icons.arrow_back,color: AppColors.mainColor,));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ProductModel> matchProducts=[];
    // List<RestaurantModel> matchRestaurants=[];
    if(query.isNotEmpty){
      matchProducts=searchProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
      // matchRestaurants=searchRestaurants.where((restaurant) => restaurant.name.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return matchProducts.isNotEmpty?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height10,),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                // mainAxisExtent: Dimensions.height10 * 25
                childAspectRatio: 1/1.38
            ),
            itemBuilder: (context, index) {
              return gridItem(matchProducts[index],
                  context);
            },
            itemCount:matchProducts.length,
          ),
        ),
      ],
    ):Column(
      children: [
        Image.asset("assets/images/NoMatch.png",height: Dimensions.height10*30,),
        const Expanded(child: Text("We're sorry, but we couldn't find any products matching your search.",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ProductModel> matchProducts=[];
    // List<RestaurantModel> matchRestaurants=[];
    if(query.isNotEmpty){
      matchProducts=searchProducts.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
      // matchRestaurants=searchRestaurants.where((restaurant) => restaurant.name.toLowerCase().contains(query.toLowerCase())).toList();
    }

    return matchProducts.isNotEmpty?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height10,),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                // mainAxisExtent: Dimensions.height10 * 25
                childAspectRatio: 1/1.38
            ),
            itemBuilder: (context, index) {
              return gridItem(matchProducts[index],
                  context);
            },
            itemCount:matchProducts.length,
          ),
        ),
      ],
    ):Column(
      children: [
        Image.asset("assets/images/NoMatch.png",height: Dimensions.height10*30,),
        const Expanded(child: Text("We're sorry, but we couldn't find any products matching your search.",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))
      ],
    );
  }

}