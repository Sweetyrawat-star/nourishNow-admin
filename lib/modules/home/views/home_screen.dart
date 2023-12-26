import 'package:admin/modules/home/bindings/bindings.dart';
import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/home/views/widgets.dart';
import 'package:admin/modules/orders_screen/bindings/bindings.dart';
import 'package:admin/modules/profile_screen/bindings/bindings.dart';
import 'package:admin/modules/restaurant_details/bindings/bindings.dart';
import 'package:admin/modules/restaurant_details/controllers/restaurant_controller.dart';
import 'package:admin/modules/restaurant_details/views/add_new_restaurant.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double stars = 2.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeBindings().dependencies();
    Get.delete<RestaurantController>(force: true);
    ProfileBindings().dependencies();

    OrdersBindings().dependencies();
  }
  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(
      builder: (controller) {
        return CustomScrollView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            //add Restaurant
            SliverToBoxAdapter(
                child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10 * 2,
                  vertical: Dimensions.height10),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 3,
                      color: Colors.black12),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Add New Restaurant",
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                  SizedBox(
                    height: Dimensions.height10 * 0.5,
                  ),
                  MaterialButton(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      Get.to(const AddEditRestaurant(),binding: RestaurantBindings());

                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.mainColor,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                ],
              ),
            )),

            // restaurants
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10 * 2,
                    vertical: Dimensions.height10 * 2),
                child: const Text("All Restaurants"),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => controller.loading
                        ? popRestLoadingItem()
                        : popRestItem(context, controller.restaurants[index]),
                    childCount: controller.restaurants.length)),
          ],
        );
      },
    );
  }
}
