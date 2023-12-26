import 'dart:math';

import 'package:admin/models/restaurant_model.dart';
import 'package:admin/modules/layout/views/layout.dart';
import 'package:admin/modules/restaurant_details/controllers/restaurant_controller.dart';
import 'package:admin/modules/restaurant_details/views/widgets.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_button.dart';
import 'package:admin/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class AddEditRestaurant extends StatefulWidget {
  final RestaurantModel? restaurantModel;
  final bool edit;
   const AddEditRestaurant({Key? key,this.edit=false,this.restaurantModel}) : super(key: key);

  @override
  State<AddEditRestaurant> createState() => _AddEditRestaurantState();
}

class _AddEditRestaurantState extends State<AddEditRestaurant> with TickerProviderStateMixin{
  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<RestaurantController>().isUpdating=widget.edit;
    if(widget.edit){
      Get.find<RestaurantController>().autoFillRestaurant(widget.restaurantModel!);
    }
    else{
      Get.find<RestaurantController>().blankRestaurant();
    }
  }
  RestaurantController controller=Get.find<RestaurantController>();
  createTabs(){
    int tabLength = 0;
    if (controller.foods.isNotEmpty) tabLength++;
    if (controller.desserts.isNotEmpty) tabLength++;
    if (controller.beverages.isNotEmpty) tabLength++;
    if (tabLength > 0) {
      _tabController = TabController(length: tabLength, vsync: this);
    }
    else{
      _tabController=null;
    }
  }
  @override
  Widget build(BuildContext context) {


    final formKey =GlobalKey<FormState>();
    return Scaffold(body: GetBuilder<RestaurantController>(
      builder: (controller) {
        createTabs();
        int maxL=max(max(controller.foods.length,controller.desserts.length),controller.beverages.length);
        int lines=(maxL~/2)+(maxL%2);
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10 * 2,
                  ),
                  child: Form(
                    key:formKey ,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text(
                          widget.edit?"To save your changes, please press the button below":"Please fill in the form to add a new restaurant",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: AppColors.mainColor),
                        ),
                        SizedBox(height: Dimensions.height10),
                        Column(
                          children: [
                            InkWell(
                              borderRadius:
                              BorderRadius.circular(20),
                              onTap: () {

                                controller.getRestaurantImage();
                              },
                              child: Container(

                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  height: Dimensions.height10 * 16,
                                  width: Dimensions.width10 * 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit:(controller.restaurantImage!= null||controller.restaurantNetImage!=null?BoxFit.cover:null) ,
                                          image:
                                          controller.restaurantImage != null?FileImage(controller.restaurantImage!):
                                          ( controller.restaurantNetImage!=null
                                              ?NetworkImage(controller.restaurantNetImage!)
                                              :const AssetImage("assets/images/add.png")
                                          as ImageProvider )
                                      )
                                  ),
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    padding: EdgeInsets.only(
                                        bottom: Dimensions.height10 * 0.7),
                                    width: double.infinity,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          stops: const [
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
                                  )
                              ),
                            ),
                            SizedBox(height: Dimensions.height10*0.5,),
                            const Text(
                              "Restaurant Image",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height10 * 2),
                        //fields
                        CustomFormField(
                          margin: EdgeInsets.zero,
                          radius: 5,
                          hintText: "Restaurant Name",
                          prefixIcon: Icons.restaurant,
                          controller: controller.restaurantName,
                          validator: controller.restaurantValidator,
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 1.5,
                        ),
                        CustomFormField(
                          margin: EdgeInsets.zero,
                          radius: 5,
                          hintText: "Restaurant Description",
                          prefixIcon: Icons.description_outlined,
                          controller: controller.restaurantDescription,
                          validator: controller.restaurantValidator,
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 1.5,
                        ),
                        CustomFormField(
                          margin: EdgeInsets.zero,
                          radius: 5,
                          hintText: "Restaurant Quote (Optional)",
                          prefixIcon: Icons.sticky_note_2_outlined,
                          controller: controller.restaurantQuote,
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 1.5,
                        ),
                        CustomFormField(
                          margin: EdgeInsets.zero,
                          radius: 5,
                          hintText: "Restaurant Speciality",
                          prefixIcon: Icons.abc,
                          controller: controller.restaurantSpeciality,
                          validator: controller.restaurantValidator,
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 1.5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              unratedColor: AppColors.greyColor.withOpacity(.5),
                              itemSize: 35,
                              initialRating: controller.rating,
                              minRating: 1,
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
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        CustomFormField(
                          isNumberNonDecimal: true,
                          margin: EdgeInsets.zero,
                          radius: 5,
                          hintText: "Ratings (Optional)",
                          prefixIcon: Icons.star_border,
                          controller: controller.restaurantRatings,
                          // validator: controller.nameValidator,
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 2,
                        ),
                        const Text(
                          "Add Product",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Dimensions.height10 * 2,
                        ),
                        product(context,key:formKey),
                        SizedBox(
                          height: Dimensions.height10 * 2,
                        ),
                           _tabController==null?Container():Column(
                            children: [
                              _tabController!.length!=0?TabBar(
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  labelColor: AppColors.mainColor,
                                  controller: _tabController,
                                  labelStyle: const TextStyle(fontSize: 20),
                                  unselectedLabelColor: AppColors.greyColor,
                                  unselectedLabelStyle: const TextStyle(fontSize: 20),
                                  tabs: [
                                    if(controller.foods.isNotEmpty)
                                      const Tab(
                                        child: Text("foods"),
                                      ),
                                    if(controller.desserts.isNotEmpty)
                                      const Tab(
                                        child: Text(
                                          "desserts",
                                        ),
                                      ),
                                    if(controller.beverages.isNotEmpty)
                                      const Tab(
                                        child: Text("beverages"),
                                      ),
                                  ]):Container()

                            ],
                          ),



                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10 * 2,
                ),
                _tabController==null?Container(): Container(
                  height: Dimensions.height10*27*lines ,
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                  child: _tabController!.length!=0?TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController,
                    children: [
                      if(controller.foods.isNotEmpty)
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
                              fromEdit: true,
                                controller.foods[index],
                                context);
                          },
                          itemCount: controller.foods.length,
                        ),
                      if(controller.desserts.isNotEmpty)
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
                                  fromEdit: true,
                                    controller.desserts[index],
                                    context));
                          },
                          itemCount: controller.desserts
                              .length,
                        ),
                      if(controller.beverages.isNotEmpty)
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
                                  fromEdit: true,
                                    controller.beverages[index],
                                    context));
                          },
                          itemCount: controller.beverages
                              .length,
                        ),
                    ],
                  ):null,
                ),
                controller.loading?Center(child: CircularProgressIndicator(color: AppColors.mainColor),):
                CustomButton(
                  onPressed: () async{
                    if(formKey.currentState!.validate()){
                      if(controller.restaurantImage==null&&controller.restaurantNetImage==null){
                        Get.snackbar("Image", "Please add an Image to your restaurant",colorText: Colors.red);
                      }
                      else if(controller.beverages.isEmpty&&controller.foods.isEmpty&&controller.desserts.isEmpty){
                        Get.snackbar("Product", "You need to add at least one product",colorText: Colors.red);
                      }
                      else{
                        if(!widget.edit) {
                          await controller.addRestaurant();
                          Get.back();
                          Get.snackbar("Add","Restaurant added successfully!",colorText: AppColors.mainColor);
                        }
                        else{
                          await controller.updateRestaurant();
                          Get.offAll(const HomeLayOutScreen());
                          Get.snackbar("Update","Restaurant Updated successfully!",colorText: AppColors.mainColor);
                        }

                      }
                    }
                  },
                  buttonText: widget.edit?"Update":"ADD",
                  width: Dimensions.width10 * 15,
                  radius: 15,
                ),
                SizedBox(
                  height: Dimensions.height10 * 2,
                ),
                widget.edit&&!controller.loading?Column(
                  children: [
                    CustomButton(
                      center: true,
                      filledColor: Colors.red,
                      icon: Icons.delete_forever_outlined,
                      onPressed: () async{
                        showDialog(context: context, builder: (context) => AlertDialog(
                          title: const Text("Are you sure you want to delete this restaurant?",style: TextStyle(color: Colors.red),),
                          content: const Text("Please note that if you proceed with this action, all details and products associated with this restaurant will be permanently deleted"),
                          actions: [

                            TextButton(onPressed: (){
                              Get.back();
                            }, child: const Text("Cancel",style: TextStyle(color: Colors.red),)),
                            TextButton(onPressed: (){
                              Get.back();
                              controller.removeRestaurant();

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
        );
      },
    ));
  }
}
