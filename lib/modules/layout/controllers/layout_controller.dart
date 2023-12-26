import 'package:admin/modules/home/views/home_screen.dart';
import 'package:admin/modules/orders_screen/view/orders_screen.dart';
import 'package:admin/modules/profile_screen/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LayoutController extends GetxController {
  List<Widget> bodyScreens = [
    const HomeScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];
  List<String> appBarTexts = [
    "Home",
    "Orders",
    "Profile",
  ];
  int screenIndex = 0;
    PageController? pageController;

  @override
  void onInit() async {
    super.onInit();
     // await getRestaurants();
     // await getAllProducts();
      update();
    pageController=PageController(
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController!.dispose();
  }

  void changeScreen(int index) {
    screenIndex = index;
    update();
  }


  //drop down button
String? dropDownValue="Popularity";
List<String> dropDownChoices=["Popularity","Price"];
  void onChanged(String? value){
    dropDownValue=value;
    update();
  }





}
