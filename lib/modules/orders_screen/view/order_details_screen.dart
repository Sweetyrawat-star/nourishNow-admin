import 'package:admin/models/order_model.dart';
import 'package:admin/modules/orders_screen/view/widgets.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;

  const OrderDetailsScreen({Key? key, required this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //Payment method
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Method :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: Dimensions.width10 * 0.5,
                  ),
                  Text(
                    "${orderModel.paymentMethod}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: AppColors.mainColor),
                  ),
                ],
              ),
            ),
            //paymentId
            orderModel.paymentId==null?Container():Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Id :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: Dimensions.width10 * 0.5,
                  ),
                  Expanded(
                    child: Text(
                      "${orderModel.paymentId}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: AppColors.mainColor),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Dimensions.height10 * 15,
              margin: EdgeInsets.all(Dimensions.height10 * 0.3),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(Dimensions.height10 * 0.5),
                  border:
                  Border.all(color: AppColors.mainColor, width: 1)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    onTap: (latLng){
                      // Get.off(PickAddressMap());
                    },
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(target: LatLng(double.parse(orderModel.addressModel.latitude!),double.parse(orderModel.addressModel.longitude!)),zoom: 16),
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: false,
                    onCameraIdle: () {
                      // locationController.updatePosition();
                    },
                    onCameraMove: (position) {

                    },
                    onMapCreated: (GoogleMapController controller) {
                      // locationController.mapController = controller;
                    },
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/marker.png',
                      width: Dimensions.width10 * 3,
                      height: Dimensions.height10 * 3,
                    ),
                  ),
                ],
              ),
            ),

            //contact address
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact Address",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Dimensions.height10 * 0.5,
                  ),
                  //fields
                  CustomFormField(
                    readOnly: true,
                    margin: EdgeInsets.zero,
                    radius: 5,
                    prefixIcon: Icons.location_on,
                    initialValue: orderModel.addressModel.address!,
                    hintText: '',
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Longitude :",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: Dimensions.width10 * 0.5,
                      ),
                      //fields
                      Expanded(
                        child: CustomFormField(
                          readOnly: true,
                          margin: EdgeInsets.zero,
                          radius: 5,
                          initialValue: orderModel.addressModel.longitude!
                              .substring(0, 5),
                          hintText: '',
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width10 * 2,
                      ),
                      const Text(
                        "Latitude :",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: Dimensions.width10 * 0.5,
                      ),
                      //fields
                      Expanded(
                        child: CustomFormField(
                          readOnly: true,
                          margin: EdgeInsets.zero,
                          radius: 5,
                          initialValue:
                          orderModel.addressModel.latitude!.substring(0, 5),
                          hintText: '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //contact name
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Dimensions.height10 * 0.5,
                  ),
                  //fields
                  CustomFormField(
                    readOnly: true,
                    margin: EdgeInsets.zero,
                    radius: 5,
                    prefixIcon: Icons.person,
                    initialValue: orderModel.contactPersonName,
                    hintText: orderModel.contactPersonName,
                  ),
                ],
              ),
            ),
            //contact number
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact Number",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: Dimensions.height10 * 0.5,
                  ),
                  //fields
                  CustomFormField(
                    readOnly: true,
                    margin: EdgeInsets.zero,
                    radius: 5,
                    prefixIcon: Icons.phone,
                    initialValue: orderModel.contactPersonNumber,
                    hintText: orderModel.contactPersonNumber,
                  ),
                ],
              ),
            ),

            //items
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: const Text(
                "Products",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Wrap(
              children: List.generate(orderModel.items.length,
                  (index) => productItem(index, orderModel)),
            ),
            SizedBox(
              height: Dimensions.height10,
            ),
            //Payment method
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height10,
                  horizontal: Dimensions.width10 * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total Price :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: Dimensions.width10 * 0.5,
                  ),
                  Text(
                    "\$${orderModel.totalPrice}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: AppColors.mainColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.height10,
            ),
          ],
        ),
      ),
    );
  }
}
