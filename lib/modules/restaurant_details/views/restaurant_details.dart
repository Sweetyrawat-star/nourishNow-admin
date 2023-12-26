import 'dart:math';

import 'package:admin/models/restaurant_model.dart';
import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/layout/views/widgets.dart';
import 'package:admin/modules/restaurant_details/bindings/bindings.dart';
import 'package:admin/modules/restaurant_details/views/add_new_restaurant.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantModel restaurantModel;

  const RestaurantDetailScreen({required this.restaurantModel, Key? key})
      : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  HomeController controller=Get.find<HomeController>();
  createTabs(){
    int tabLength = 0;
    if (controller.productsPerRest[widget.restaurantModel.id]!["foods"]!.isNotEmpty) tabLength++;
    if (controller.productsPerRest[widget.restaurantModel.id]!["beverages"]!.isNotEmpty) tabLength++;
    if (controller.productsPerRest[widget.restaurantModel.id]!["desserts"]!.isNotEmpty) tabLength++;
    if (tabLength > 0) _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    createTabs();
    HomeController homeController = Get.find<HomeController>();
    int maxL=max(max(homeController.productsPerRest[widget.restaurantModel.id]!['foods']!.length,homeController.productsPerRest[widget.restaurantModel.id]!['desserts']!.length),homeController.productsPerRest[widget.restaurantModel.id]!['beverages']!.length);
    int lines=(maxL~/2)+(maxL%2);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      backgroundColor:Colors.white ,
                      radius: 20,
                      child: Icon(
                        size: 18,
                        Icons.arrow_back_ios,
                        color: AppColors.mainColor,
                      ),
                    )),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Get.to( AddEditRestaurant(edit: true,restaurantModel: widget.restaurantModel),binding: RestaurantBindings());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      size: 18,
                      Icons.edit,
                      color: AppColors.mainColor,
                    ),
                  ),
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height10 * 6.3),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: Dimensions.height10 * 1.5,
                  bottom: Dimensions.height10,
                ),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.height10 * 4),
                      topRight: Radius.circular(Dimensions.height10 * 4),
                    )),
                child: Text(
                  maxLines: 1,
                  overflow:TextOverflow.ellipsis,
                  widget.restaurantModel.name,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
            ),
            backgroundColor: AppColors.mainColor,
            pinned: true,
            expandedHeight: Dimensions.height10 * 25,
            flexibleSpace: FlexibleSpaceBar(
                background: Hero(
              tag: widget.restaurantModel.id,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              widget.restaurantModel.image,
                            ))),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            stops: const [
                              0.2,
                              0.6
                            ],
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.black54.withOpacity(0.1)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: Dimensions.height10*10),
                    child: Text(
                      maxLines: 1,
                      widget.restaurantModel.quote,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        overflow: TextOverflow.ellipsis,
                        fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 23),
                    ),
                  )
                ],
              ),
            )),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.width10 * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RatingBarIndicator(
                            itemPadding: const EdgeInsets.only(right: 5),
                            unratedColor: AppColors.mainColor.withOpacity(0.2),
                            rating: widget.restaurantModel.stars,
                            itemBuilder: (context, index) => Icon(
                              Icons.star_rounded,
                              color: AppColors.mainColor,
                            ),
                            itemCount: 5,
                            itemSize: Dimensions.height10 * 2,
                            direction: Axis.horizontal,
                          ),
                          Text(
                            "${widget.restaurantModel.stars} Star Ratings",
                            style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      //Description
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: Dimensions.height10 * 0.5,
                      ),
                      ExpandableTextWidget(
                        fontHeight: 1.3,
                        fontSize: 13.5,
                        text: widget.restaurantModel.description,
                        height: Dimensions.height10 * 16,
                      ),
                      //tabBar
                      TabBar(
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          labelColor: AppColors.mainColor,
                          controller: _tabController,
                          labelStyle: const TextStyle(fontSize: 20),
                          unselectedLabelColor: AppColors.greyColor,
                          unselectedLabelStyle: const TextStyle(fontSize: 20),
                          tabs: [
                            if(homeController.productsPerRest[widget.restaurantModel.id]!['foods']!.isNotEmpty)
                            const Tab(
                              child: Text("foods"),
                            ),
                            if(homeController.productsPerRest[widget.restaurantModel.id]!['desserts']!.isNotEmpty)
                            const Tab(
                              child: Text(
                                "desserts",
                              ),
                            ),
                            if(homeController.productsPerRest[widget.restaurantModel.id]!['beverages']!.isNotEmpty)
                            const Tab(
                              child: Text("beverages"),
                            ),
                          ]),
                    ],
                  ),
                ),
                Container(
                  height: Dimensions.height10*27*lines ,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController,
                    children: [
                      if(homeController.productsPerRest[widget.restaurantModel.id]!['foods']!.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: Dimensions.height10 * 25

                        ),
                        itemBuilder: (context, index) {
                          return gridItem(
                              homeController.productsPerRest[
                                  widget.restaurantModel.id]!['foods']![index],
                              context);
                        },
                        itemCount: homeController
                            .productsPerRest[widget.restaurantModel.id]![
                                'foods']!
                            .length,
                      ),
                      if(homeController.productsPerRest[widget.restaurantModel.id]!['desserts']!.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: Dimensions.height10 * 25

                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {},
                              child: gridItem(
                                  homeController.productsPerRest[widget
                                      .restaurantModel.id]!['desserts']![index],
                                  context));
                        },
                        itemCount: homeController
                            .productsPerRest[widget.restaurantModel.id]![
                                'desserts']!
                            .length,
                      ),
                      if(homeController.productsPerRest[widget.restaurantModel.id]!['beverages']!.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: Dimensions.height10 * 25
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {},
                              child: gridItem(
                                  homeController.productsPerRest[widget
                                      .restaurantModel
                                      .id]!['beverages']![index],
                                  context));
                        },
                        itemCount: homeController
                            .productsPerRest[widget.restaurantModel.id]![
                                'beverages']!
                            .length,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
