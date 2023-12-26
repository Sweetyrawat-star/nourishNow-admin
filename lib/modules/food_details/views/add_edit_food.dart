
import 'package:admin/models/product_model.dart';
import 'package:admin/modules/food_details/controllers/food_controller.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_button.dart';
import 'package:admin/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class AddEditFood extends StatefulWidget {
  final ProductModel? productModel;
  final bool fromProduct;

  const AddEditFood({Key? key, this.productModel,this.fromProduct=false})
      : super(key: key);

  @override
  State<AddEditFood> createState() => _AddEditFoodState();
}

class _AddEditFoodState extends State<AddEditFood> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<FoodController>().fromProduct=widget.fromProduct;
    if(widget.productModel!=null){
      Get.find<FoodController>().autoFillForm(widget.productModel!);
    }

  }
  @override
  Widget build(BuildContext context) {
    final formKey =GlobalKey<FormState>();

    return Scaffold(body: GetBuilder<FoodController>(
      builder: (controller) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10 * 2,
              ),
              child: Form(
                key:formKey ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Please fill in the form to add a new product",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: AppColors.mainColor),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            controller.getProductImage();
                          },
                          child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              height: Dimensions.height10 * 16,
                              width: Dimensions.width10 * 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      fit:controller.productImageUrl!=null||controller.productImage != null
                                          ? BoxFit.cover
                                          : null,
                                      image:controller.productImage != null?FileImage(controller.productImage!):
                                      ( controller.productImageUrl!=null
                                          ?NetworkImage(controller.productImageUrl!)
                                          :const AssetImage("assets/images/add.png")
                                      as ImageProvider ))

                              ),
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                padding: EdgeInsets.only(
                                    bottom: Dimensions.height10 * 0.7),
                                width: double.infinity,
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      stops: const
                                      [
                                        0.3,
                                        0.3
                                      ],
                                      colors: [
                                        Colors.black.withOpacity(0.04),
                                        Colors.grey.withOpacity(0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter),
                                ),
                                child: Icon(
                                  size: Dimensions.height10 * 3,
                                  Icons.camera_alt,
                                  color: AppColors.greyColor.withOpacity(.7),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 0.5,
                        ),
                        const Text(
                          "Product Image",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10 * 2),
                    Row(
                      children: [
                        const Text(
                          "Category",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        DropdownButton<String>(
                          iconEnabledColor: AppColors.mainColor,
                          value: controller.dropDownValue,
                          onChanged: (value) {
                            controller.onDropDownChanged(value);
                          },
                          items: List.generate(
                            controller.dropDownChoices.length,
                            (index) => DropdownMenuItem<String>(
                              value: controller.dropDownChoices[index],
                              child: Text(controller.dropDownChoices[index]),
                            ),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey[700]),
                        ),
                        SizedBox(
                          width: Dimensions.width10,
                        )
                      ],
                    ),
                    //fields
                    CustomFormField(
                      margin: EdgeInsets.zero,
                      radius: 5,
                      hintText: "Product Name",
                      prefixIcon: Icons.fastfood,
                      controller: controller.productName,
                      validator: controller.productValidator
                    ),
                    SizedBox(
                      height: Dimensions.height10 * 1.5,
                    ),
                    CustomFormField(
                      margin: EdgeInsets.zero,
                      radius: 5,
                      hintText: "Product Description",
                      prefixIcon: Icons.description_outlined,
                      controller: controller.productDescription,
                      validator: controller.productValidator,
                    ),
                    SizedBox(
                      height: Dimensions.height10 * 1.5,
                    ),
                    //price
                    Row(
                      children: [
                        const Text(
                          "Price in Dollar \$ :",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: Dimensions.width10 * 2,
                        ),
                        Expanded(
                          child: CustomFormField(
                            onChanged: (value){
                              controller.update();
                            },
                            isNumber: true,
                            margin: EdgeInsets.zero,
                            radius: 5,
                            hintText: "Price (....,..)",
                            prefixIcon: Icons.monetization_on_outlined,
                            controller: controller.productPrice,
                            validator: controller.priceValidator,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: Dimensions.height10 * 1.5,
                    ),
                    //discount
                    Row(
                      children: [
                        Text(
                          "Discount(${controller.discount.toStringAsFixed(0)}%)",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),

                        Expanded(
                          child: Slider(
                            label: "${controller.discount.toStringAsFixed(0)}%",
                            inactiveColor: AppColors.mainColor.withOpacity(.4),
                            activeColor: AppColors.mainColor,
                            min: 0,
                              max: 100,
                              divisions: 20,
                              thumbColor: AppColors.mainColor,
                              value: controller.discount, onChanged: (value) {
                              controller.onSliderChanged(value);
                          }),
                        ),
                      ],
                    ),
                    controller.discount!=0&&controller.productPrice.text.isNotEmpty?Column(
                      children: [
                        SizedBox(
                          height: Dimensions.height10 * 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New Price :",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600,color: AppColors.mainColor),
                            ),
                            SizedBox(width: Dimensions.width10*2,),
                            Expanded(child: Text(controller.productPrice.text.isNotEmpty?"\$${(double.parse(controller.productPrice.text)-(double.parse(controller.productPrice.text)*controller.discount/100)).toStringAsFixed(2)}":"",maxLines: 1,))
                          ],
                        ),
                      ],
                    ):Container(),
                    SizedBox(
                      height: Dimensions.height10 * 1.5,
                    ),
                    //rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          unratedColor: AppColors.greyColor.withOpacity(.5),
                          itemSize: 35,
                          initialRating: controller.rating,
                          minRating: 0.5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: AppColors.mainColor,
                          ),
                          onRatingUpdate: (rating) {
                            controller.setRating(rating);
                          },
                        ),
                        const Spacer(),
                        Text(
                          "Rating: ${controller.rating}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: Dimensions.height10 * 1.5,
                    ),
                    CustomFormField(
                      isNumberNonDecimal: true,
                      margin: EdgeInsets.zero,
                      radius: 5,
                      hintText: "Ratings (Optional)",
                      prefixIcon: Icons.star_border,
                      controller: controller.productRatings,
                    ),
                    SizedBox(
                      height: Dimensions.height10 * 2,
                    ),
                    controller.loading?Center(child: CircularProgressIndicator(color: AppColors.mainColor),):CustomButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          if(controller.productImage==null&&controller.productImageUrl==null){
                            Get.snackbar("Image", "Please add an Image to your product",colorText: Colors.red);
                          }
                          else{
                            if(controller.fromProduct){
                              controller.updateProduct();
                            }
                            else {
                              controller.addProduct();
                            }
                          }
                        }
                      },
                      buttonText:widget.productModel!=null?"UPDATE": "ADD",
                      width: Dimensions.width10 * 15,
                      radius: 15,
                    ),
                    SizedBox(
                      height: Dimensions.height10 * 2,
                    ),
                    widget.productModel!=null&&!controller.loading?Column(
                      children: [
                        CustomButton(
                          center: true,
                          filledColor: Colors.red,
                          icon: Icons.delete_forever_outlined,
                          onPressed: () async{
                            // "Are you sure you want to delete this restaurant? "
                            showDialog(context: context, builder: (context) => AlertDialog(
                              title: const Text("Are you sure you want to delete this product?",style: TextStyle(color: Colors.red),),
                              content: const Text("Please note that if you proceed with this action, all details associated with this product will be permanently deleted"),
                              actions: [

                                TextButton(onPressed: (){
                                  Get.back();

                                }, child: const Text("Cancel",style: TextStyle(color: Colors.red),)),
                                TextButton(onPressed: (){
                                  Get.back();
                                  controller.removeProd(widget.productModel!);
                                }, child: const Text("Proceed",style: TextStyle(color: Colors.red),)),
                              ],
                            ),);
                          },
                          buttonText: "Delete",
                          width: Dimensions.width10 * 15,
                          radius: 15,
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 2,
                        ),
                      ],
                    ):Container()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
