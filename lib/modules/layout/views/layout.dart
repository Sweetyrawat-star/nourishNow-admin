import 'package:admin/modules/layout/controllers/layout_controller.dart';
import 'package:admin/modules/layout/views/search_delgate.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeLayOutScreen extends StatefulWidget {
  const HomeLayOutScreen({Key? key}) : super(key: key);

  @override
  State<HomeLayOutScreen> createState() => _HomeLayOutScreenState();
}

class _HomeLayOutScreenState extends State<HomeLayOutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutController>(
        builder: (controller) => Scaffold(
              appBar: AppBar(
                actions: [
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: (){
                      showSearch(context: context, delegate:CustomSearchDelegate(), );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10 * 2.1),
                      child: Icon(
                        Icons.search,
                        size: 25,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                ],
                centerTitle: false,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark),
                title: Padding(
                  padding: EdgeInsets.only(left: Dimensions.width10 * 0.5),
                  child: Text(controller.appBarTexts[controller.screenIndex],
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              body: controller.pageController != null
                  ? PageView.builder(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                      physics: const BouncingScrollPhysics(),
                      controller: controller.pageController,
                      onPageChanged: (index) {
                        controller.changeScreen(index);
                      },
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return controller.screenIndex!=1?ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            controller.bodyScreens[controller.screenIndex],
                          ],
                        ):controller.bodyScreens[controller.screenIndex];
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index){
                  controller.changeScreen(index);
                  controller.pageController!.jumpToPage(index);
                },
                type: BottomNavigationBarType.shifting,
                iconSize: 30,
                showUnselectedLabels: false,
                currentIndex: controller.screenIndex,
                backgroundColor: Colors.white,
                elevation: 10,
                unselectedItemColor: AppColors.greyColor,
                selectedItemColor: AppColors.mainColor,
                items: [
                  BottomNavigationBarItem(icon: const Icon(Icons.home),label: controller.appBarTexts[0]),
                  BottomNavigationBarItem(icon: const Icon(Icons.shopping_bag),label: controller.appBarTexts[1]),
                  BottomNavigationBarItem(icon: const Icon(Icons.person),label: controller.appBarTexts[2]),
                ],
              ),
              extendBody: true,
            ));
  }
}
