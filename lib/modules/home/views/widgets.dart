import 'package:admin/models/restaurant_model.dart';
import 'package:admin/modules/restaurant_details/views/restaurant_details.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';


Widget popRestItem(context,RestaurantModel model) => InkWell(
  onTap: (){
    Get.to(RestaurantDetailScreen(restaurantModel: model));
  },
  child:   Column(

    children: [


      Hero(
        tag: model.id,
        child: Container(

          height: Dimensions.height10 * 19,

          width: double.infinity,

          decoration: BoxDecoration(

              image: DecorationImage(

                  image: NetworkImage(model.image),

                  fit: BoxFit.cover)),

        ),
      ),

      SizedBox(

        height: Dimensions.height10 * 0.7,

      ),

      Padding(

        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10 * 2),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              model.name,

              style: Theme.of(context).textTheme.bodyMedium!.copyWith(

                  fontWeight: FontWeight.bold,

                  fontSize: Dimensions.height10 * 1.65),

            ),

            SizedBox(

              height: Dimensions.height10 * 0.5,

            ),

            Row(

              children: [

                Icon(

                  Icons.star,

                  color: AppColors.mainColor,

                  size: 25,

                ),

                RichText(

                    text: TextSpan(

                        style: TextStyle(

                            color: AppColors.greyColor,

                            fontWeight: FontWeight.w300,

                            fontSize: Dimensions.height10 * 1.25),

                        children: [

                          TextSpan(

                              text: ' ${model.stars} ',

                              style: TextStyle(

                                  color: AppColors.mainColor,

                                  fontWeight: FontWeight.w400,

                                  fontSize: Dimensions.height10 * 1.6)),

                          TextSpan(text: "(${model.ratings} ratings) Restaurant"),

                          TextSpan(

                              text: ' . ',

                              style: TextStyle(

                                  color: AppColors.mainColor,

                                  fontWeight: FontWeight.w800,

                                  fontSize: Dimensions.height10 * 2)),

                          TextSpan(text: model.speciality),

                        ]))

              ],

            ),

            SizedBox(

              height: Dimensions.height10 * 3,

            ),

          ],

        ),

      ),

    ],

  ),
);

Widget popRestLoadingItem(){
  return Column(
crossAxisAlignment: CrossAxisAlignment.start,
    children: [


      Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.3),
        highlightColor:Colors.grey.withOpacity(.15) ,
        child: Container(

          height: Dimensions.height10 * 19,

          width: double.infinity,

          color: Colors.black,

        ),
      ),

      SizedBox(

        height: Dimensions.height10 * 0.7,

      ),

      Padding(

        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10 * 2),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(.2),
              highlightColor:Colors.grey.withOpacity(.1) ,
              child: Container(
                color: Colors.black,
                height: Dimensions.height10 * 3,
                width: Dimensions.width10*10,
              ),
            ),

            SizedBox(

              height: Dimensions.height10 * 0.5,

            ),

            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(.2),
              highlightColor:Colors.grey.withOpacity(.1) ,
              child: Container(
                color: Colors.black,
                height: Dimensions.height10 * 3,
                width: Dimensions.width10*25,
              ),
            ),

            SizedBox(

              height: Dimensions.height10 * 3,

            ),

          ],

        ),

      ),

    ],

  );
}