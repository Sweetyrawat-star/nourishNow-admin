import 'package:admin/models/product_model.dart';
import 'package:admin/modules/food_details/bindings/bindings.dart';
import 'package:admin/modules/food_details/views/add_edit_food.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FoodDetailScreen extends StatefulWidget {
  final ProductModel productModel;

   const FoodDetailScreen({required this.productModel,Key? key,}) : super(key: key);

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {

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
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Get.back();
                    },
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
                    Get.to(AddEditFood(productModel:widget.productModel,fromProduct: true,),binding: FoodBindings());
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
              preferredSize: Size.fromHeight(Dimensions.height10 * 8.2),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: Dimensions.height10 * 2.2,
                ),
                padding: EdgeInsets.only(
                    top: Dimensions.height10 * 3,
                    bottom: 10,
                    left: Dimensions.width10 * 2),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.height10 * 4),
                      topRight: Radius.circular(Dimensions.height10 * 4),
                    )),
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  widget.productModel.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            backgroundColor: AppColors.mainColor,
            pinned: true,
            expandedHeight: Dimensions.height10 * 32,
            flexibleSpace:
            FlexibleSpaceBar(
                background: Hero(
                  tag: widget.productModel.id,
                  child: Image.network(widget.productModel.img,fit: BoxFit.cover,
                    width: double.maxFinite,),
                )

                ),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBarIndicator(
                                itemPadding: const EdgeInsets.only(right: 5),
                                unratedColor:
                                    AppColors.mainColor.withOpacity(0.2),
                                rating: widget.productModel.stars,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: AppColors.mainColor,
                                ),
                                itemCount: 5,
                                itemSize: Dimensions.height10 * 2,
                                direction: Axis.horizontal,
                              ),
                              SizedBox(
                                height: Dimensions.height10 * 0.5,
                              ),
                              Text(
                                "${widget.productModel.stars} Star Ratings",
                                style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: Dimensions.height10 * 2,
                              ),
                            ],
                          ),

                          !widget.productModel.inDiscount?Text("\$${widget.productModel.price}",style: TextStyle(fontSize:50,fontWeight: FontWeight.w700,color: AppColors.mainColor),):
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(text: widget.productModel.price.toString(),style: TextStyle(fontSize: 20,decoration: TextDecoration.lineThrough,decorationThickness: 2,color: Colors.black12.withOpacity(0.5))),
                                const TextSpan(text: "   "),
                                TextSpan(text:"\$${widget.productModel.discount}",style: TextStyle(fontSize: 45,fontWeight: FontWeight.w700,color:AppColors.mainColor)),
                              ]
                          ),)
                        ],
                      ),
                      //Description
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ExpandableTextWidget(
                        text:widget.productModel.description,
                        height: Dimensions.height10 * 17.2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
