
import 'package:admin/models/product_model.dart';
import 'package:admin/modules/food_details/bindings/bindings.dart';
import 'package:admin/modules/food_details/views/add_edit_food.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget gridItem( ProductModel model,context,{fromEdit=false}){
  return Stack(
    alignment: Alignment.topRight,
    children: [
      InkWell(
        onTap: (){
          if(fromEdit){
            Get.to(AddEditFood(productModel: model),binding: FoodBindings(),);
          }
          // Get.to(FoodDetailScreen(productModel: model));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width10*0.5),
          height: Dimensions.height10*25,
          width: double.infinity,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: model.id,
                child: Container(
                  height: Dimensions.height10*16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image:model.fileImage!=null?FileImage(model.fileImage!): NetworkImage(model.img) as ImageProvider,fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    SizedBox(height: Dimensions.height10*0.5,),
                    Text("\$${model.price}",maxLines: 1,style: TextStyle(fontSize: 16,color: AppColors.greyColor)),
                    SizedBox(height: Dimensions.height10*0.5),
                    Row(
                      children: [
                        Text("${model.stars} ",maxLines: 1,style: const TextStyle(fontSize: 16)),
                        Icon(Icons.star_rounded,color: AppColors.mainColor,)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

    ],
  );
}

Widget product(context,{ required GlobalKey<FormState> key}){
 return
   InkWell(
   onTap: (){
     if(key.currentState!.validate()){
         Get.to(const AddEditFood(),binding: FoodBindings());
     }
     else{
       Get.snackbar("Form", "Please fill in the previous fields first",colorText: Colors.red);
     }

   },
   child: Container(
     height: Dimensions.width10 * 11,
     width: Dimensions.width10 * 11,
     decoration: BoxDecoration(
         border: Border.all(color: AppColors.mainColor,width: 1),
         color: Colors.white,
         borderRadius: BorderRadius.circular(20),
     ),
     child:Icon(Icons.add,size: 50,color: AppColors.mainColor,),
   ),
 );
}