import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/home/views/widgets.dart';
import 'package:admin/modules/layout/controllers/layout_controller.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Get.find<HomeController>().searchController.clear();
  }
  @override
  Widget build(BuildContext context) {
    LayoutController controller = Get.find<LayoutController>();
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
            automaticallyImplyLeading: true,
            title: Padding(
              padding: EdgeInsets.only(left: Dimensions.width10 * 0.5),
              child: Text('Restaurants',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            actions: [
              InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () {
                  // Get.to(const CartScreen());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10 * 2.1),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 25,
                    color: AppColors.mainColor,
                  ),
                ),
              )
            ],
          ),
          body: CustomScrollView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              //search field
              SliverToBoxAdapter(
                child: CustomFormField(
                  onChanged: (value) {
                    homeController.search(homeController.restaurants, value);
                  },
                  controller: homeController.searchController,
                  hintText: 'Search restaurant',
                  margin: EdgeInsets.symmetric(
                      vertical: Dimensions.height10 * 3,
                      horizontal: Dimensions.width10 * 2),
                  prefixIcon: Icons.search,
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                if (homeController.searchController.text.isEmpty) {
                  return popRestItem(
                      context, homeController.restaurants[index]);
                }
                else{
                  return popRestItem(
                      context, homeController.searchedRestaurants[index]);
                }
              }, childCount:homeController.searchController.text.isEmpty? homeController.restaurants.length:homeController.searchedRestaurants.length

                  )),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: Dimensions.height10 * 13,
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: InkWell(
            onTap: () {
              Get.back();
              controller.changeScreen(2);
              controller.pageController!.animateToPage(controller.screenIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            child: CircleAvatar(
              backgroundColor: controller.screenIndex != 2
                  ? AppColors.greyColor
                  : AppColors.mainColor,
              radius: Dimensions.height10 * 3.6,
              child: Icon(
                Icons.home,
                size: Dimensions.height10 * 4,
                color: Colors.white,
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 18,
            shape: const CircularNotchedRectangle(),
            color: Colors.white,
            elevation: 100,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.changeScreen(0);
                      controller.pageController!.animateToPage(
                          controller.screenIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: Container(
                      height: Dimensions.height10 * 9,
                      padding: EdgeInsets.only(left: Dimensions.width10 * 1.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.grid_view_rounded,
                                size: Dimensions.height10 * 2.8,
                                color: controller.screenIndex != 0
                                    ? AppColors.greyColor
                                    : AppColors.mainColor,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Menu",
                                style: TextStyle(
                                    fontSize: Dimensions.height10 * 1.5,
                                    color: controller.screenIndex != 0
                                        ? AppColors.greyColor
                                        : AppColors.mainColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.changeScreen(1);
                      controller.pageController!.animateToPage(
                          controller.screenIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: Container(
                      height: Dimensions.height10 * 9,
                      padding: EdgeInsets.only(left: Dimensions.width10 * 1.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: Dimensions.height10 * 2.8,
                                color: controller.screenIndex != 1
                                    ? AppColors.greyColor
                                    : AppColors.mainColor,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Favorite",
                                style: TextStyle(
                                    fontSize: Dimensions.height10 * 1.4,
                                    color: controller.screenIndex != 1
                                        ? AppColors.greyColor
                                        : AppColors.mainColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dimensions.width10 * 11.4,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.changeScreen(3);
                      controller.pageController!.animateToPage(
                          controller.screenIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: Container(
                      alignment: AlignmentDirectional.bottomEnd,
                      height: Dimensions.height10 * 9,
                      padding: EdgeInsets.only(right: Dimensions.width10 * 1.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: Dimensions.height10 * 2.8,
                                color: controller.screenIndex != 3
                                    ? AppColors.greyColor
                                    : AppColors.mainColor,
                              ),
                              Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: Dimensions.height10 * 1.5,
                                    color: controller.screenIndex != 3
                                        ? AppColors.greyColor
                                        : AppColors.mainColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      controller.changeScreen(4);
                      controller.pageController!.animateToPage(
                          controller.screenIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: Container(
                      alignment: AlignmentDirectional.bottomEnd,
                      height: Dimensions.height10 * 9,
                      padding: EdgeInsets.only(right: Dimensions.width10 * 1.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.format_indent_increase_outlined,
                                size: Dimensions.height10 * 2.8,
                                color: controller.screenIndex != 4
                                    ? AppColors.greyColor
                                    : AppColors.mainColor,
                              ),
                              Text(
                                "More",
                                style: TextStyle(
                                  fontSize: Dimensions.height10 * 1.5,
                                  color: controller.screenIndex != 4
                                      ? AppColors.greyColor
                                      : AppColors.mainColor,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          extendBody: true,
        );
      },
    );
  }
}
