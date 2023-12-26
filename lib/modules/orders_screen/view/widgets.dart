

import 'package:admin/models/order_model.dart';
import 'package:admin/modules/orders_screen/controller/orders_controller.dart';
import 'package:admin/modules/orders_screen/view/order_details_screen.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


Widget orderItems (OrderModel order,context) {
  OrdersController ordersController=Get.find<OrdersController>();

  Color color;
  switch(order.state.toLowerCase()){
    case "in process":
      color=AppColors.mainColor;
      break;
    case "pending":
      color=Colors.amber;
      break;
    case "declined":
      color=Colors.red;
      break;
    case "canceled":
      color=AppColors.mainColor;
      break;
      default:
    color=Colors.green;
    break;
  }

  return Padding(
  padding: EdgeInsets.only(
      top: Dimensions.height10 * 2,
      right: Dimensions.height10 * 1.5,
      left: Dimensions.height10 * 1.5),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(DateFormat(order.state.toLowerCase()=="declined"||order.state.toLowerCase()=="delivered"?'dd/MM/yyyy hh:mm a':'hh:mm a').format(DateTime.parse(order.time)),style: const TextStyle(fontSize:18),),
          const Spacer(),
          order.state.toLowerCase()=="pending"||order.state.toLowerCase()=="in process"?SizedBox(width:Dimensions.width10*8,child: LinearProgressIndicator(color:order.state.toLowerCase()=="in process"?AppColors.mainColor: Colors.amberAccent,minHeight: 3.5,)):Container(),
          SizedBox(width: Dimensions.width10,),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.width10*0.6),
              color: color,
            ),
            width: Dimensions.width10*8,
            height: Dimensions.height10*2.2,
            child: Text(order.state,style: const TextStyle(color: Colors.white,fontSize: 16),),
          ),
          SizedBox(width: Dimensions.width10,),
          order.state.toLowerCase()=="delivered"||order.state.toLowerCase()=="declined"?InkWell(
            borderRadius: BorderRadius.circular(10),
              onTap: (){
              ordersController.updateState(order, delete: true);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8,left: 8),
                child: Icon(Icons.delete_forever_outlined,color: Colors.red,size: Dimensions.height10*2.8,),
              )):Container(),
        ],
      ),
      const SizedBox(height: 10,),
      //items
      SizedBox(
        height:  Dimensions.height10 * 8.5,
        child: Row(
          children: [
            Wrap(
                children: List.generate(
                  order.items.length > 3 ? 3 : order.items.length,
                      (index) => Container(
                    margin: EdgeInsets.only(right: Dimensions.width10,top: Dimensions.height10*1.5),
                    width: Dimensions.width10 * 7,
                    height: Dimensions.height10 * 7,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(order.items[index].product.img)),
                        borderRadius: BorderRadius.circular(Dimensions.height10)),
                  ),
                )),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: Dimensions.height10*.5,),
                const Text( 'Total',style: TextStyle(fontSize: 18),),
               Text( '${order.items.length} Items',style: const TextStyle(fontSize: 22)),
                CustomButton(onPressed: (){
                  Get.to(OrderDetailsScreen(orderModel: order,));
                },transparent: true,buttonText:"more details",height: Dimensions.height10*3,width: Dimensions.width10*11, ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: Dimensions.height10*2,),
      //location
      Row(
        children: [
          Icon(Icons.location_on_outlined,color: AppColors.mainColor,),
          const SizedBox(width: 5,),
          Expanded(child: Text(order.addressModel.address!,style: const TextStyle(fontSize:18),maxLines: 1,overflow: TextOverflow.ellipsis,)),
        ],
      ),
      SizedBox(height: Dimensions.height10,),
      //buttons
      order.state.toLowerCase()=="pending"||order.state.toLowerCase()=="in process"?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(onPressed: (){

            ordersController.updateState(order, state:order.state.toLowerCase()=="pending"?"in process":"Delivered");

          },filledColor: Colors.green,buttonText:order.state.toLowerCase()=="pending"?"Accept":"Delivered",height: Dimensions.height10*3,width: Dimensions.width10*9, ),
          SizedBox(width: Dimensions.width10*2,),
          CustomButton(onPressed: (){
            ordersController.updateState(order, state: "declined");
          },buttonText:"Decline",height: Dimensions.height10*3,width: Dimensions.width10*9,filledColor: Colors.red),
        ],
      ):Container()
    ],
  ),
);
}

Widget divider()=>Container(
  margin: EdgeInsets.only(top: Dimensions.height10,right: Dimensions.width10*2,left: Dimensions.width10*2),
  height: 1,color: AppColors.mainColor,);

productItem(int index,OrderModel orderModel){
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: Dimensions.width10*.5, vertical: Dimensions.height10*.5),
    decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.05),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30))),
    height: Dimensions.height10 * 18,
    width: Dimensions.width10 * 18,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(

                  image: NetworkImage(
                      orderModel.items[index].product.img),
                  fit: BoxFit.cover
              ),
              color: Colors.red,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30))),

          height: Dimensions.height10 * 10,
          width: Dimensions.width10 * 18,
        ),
        SizedBox(height: Dimensions.height10*.5,),
        Text(orderModel.items[index].product.name,style: TextStyle(fontSize: 17,color: AppColors.mainColor,fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),
        Row(
          children: [
            const Text("Quantity : ",style: TextStyle(fontSize: 17),maxLines: 1,overflow: TextOverflow.ellipsis,),
            Text(orderModel.items[index].quantity.toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: AppColors.mainColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
        Row(
          children: [
            const Text("Price : ",style: TextStyle(fontSize: 17),maxLines: 1,overflow: TextOverflow.ellipsis,),
            Text(orderModel.items[index].product.inDiscount?"\$${orderModel.items[index].product.discount!.toStringAsFixed(2)}":"\$${orderModel.items[index].product.price.toStringAsFixed(2)}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: AppColors.mainColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ],
        ),
        Row(
          children: [
            const Text("from ",style: TextStyle(fontSize: 17),maxLines: 1,overflow: TextOverflow.ellipsis,),
            Expanded(child: Text(orderModel.items[index].product.restName!,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,color: AppColors.mainColor),maxLines: 1,overflow: TextOverflow.ellipsis,)),
          ],
        )

      ],
    ),
  );
}

