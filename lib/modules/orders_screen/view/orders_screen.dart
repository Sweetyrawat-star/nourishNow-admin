import 'package:admin/modules/orders_screen/controller/orders_controller.dart';
import 'package:admin/modules/orders_screen/view/widgets.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrdersController>(builder: (ordersController) {
        return ordersController.loading?Center(child: CircularProgressIndicator(color: AppColors.mainColor,)):Column(
          children: [
            TabBar(
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                labelColor: AppColors.mainColor,
                controller: _tabController,
                labelStyle: const TextStyle(fontSize: 20),
                unselectedLabelColor: AppColors.greyColor,
                unselectedLabelStyle: const TextStyle(fontSize: 20),
                tabs: const [
                  Tab(
                    child: Text("Pending",style: TextStyle(fontSize: 16),),
                  ),
                  Tab(
                    child: Text("In Process",style: TextStyle(fontSize: 16),),
                  ),
                  Tab(
                    child: Text("Delivered",style: TextStyle(fontSize: 16),),
                  ),
                  Tab(
                    child: Text(
                        "Declined",style: TextStyle(fontSize: 16)
                    ),
                  ),

                ]),
            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  //pending
                  ordersController.pendingOrders.isEmpty?Column(
                    children: [
                      Image.asset("assets/images/emptyOrders.png",width: double.infinity,height: Dimensions.height10*50,),
                      const Text("There's no orders yet !!")
                    ],
                  ):ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ordersController.pendingOrders.length,
                    separatorBuilder: (context, index) {
                      return divider();
                    },
                    itemBuilder: (context, index) {
                      return orderItems(ordersController.pendingOrders[index],  context);
                    },),
                  //in process
                  ordersController.inProcessOrders.isEmpty?Column(
                    children: [
                      Image.asset("assets/images/emptyOrders.png",width: double.infinity,height: Dimensions.height10*50,),
                      const Text("There's no Orders in process.")
                    ],
                  ):ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ordersController.inProcessOrders.length,
                    separatorBuilder: (context, index) {
                      return divider();
                    },
                    itemBuilder: (context, index) {
                      return orderItems(ordersController.inProcessOrders[index],  context,);
                    },),
                  //delivered
                  ordersController.deliveredOrders.isEmpty?Column(
                    children: [
                      Image.asset("assets/images/emptyHistory.png",width: double.infinity,height: Dimensions.height10*50,),
                      const Text("Empty History !!")
                    ],
                  ):ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ordersController.deliveredOrders.length,
                    separatorBuilder: (context, index) {
                      return divider();
                    },
                    itemBuilder: (context, index) {
                      return orderItems(ordersController.deliveredOrders[index],  context);
                    },),
                  //declined
                  ordersController.declinedOrders.isEmpty?Column(
                    children: [
                      Image.asset("assets/images/emptyHistory.png",width: double.infinity,height: Dimensions.height10*50,),
                      const Text("Empty History !!")
                    ],
                  ):ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ordersController.declinedOrders.length,
                    separatorBuilder: (context, index) {
                      return divider();
                    },
                    itemBuilder: (context, index) {
                      return orderItems(ordersController.declinedOrders[index],  context);
                    },),

                ],
              ),
            ),
            SizedBox(height: Dimensions.height10*1.5,)
          ],
        );
      },)
    );
  }
}
