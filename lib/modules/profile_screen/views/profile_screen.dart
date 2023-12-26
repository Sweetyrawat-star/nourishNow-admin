
import 'package:admin/data/auth_repository/auth_repo.dart';
import 'package:admin/modules/profile_screen/controllers/profile_controller.dart';
import 'package:admin/modules/profile_screen/views/widgets.dart';

import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_button.dart';
import 'package:admin/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationRepository authController = Get.find<AuthenticationRepository>();
    final formKey = GlobalKey<FormState>();
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: controller.loadingData?loadingWidget(): Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //profile
                Column(
                  children: [
                    SizedBox(
                      height: Dimensions.height10 * 3,
                    ),
                    InkWell(
                      borderRadius:
                          BorderRadius.circular(Dimensions.height10 * 7),
                      onTap: () {
                        if (controller.editingProfile) {
                          controller.getProfileImage();
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        height: Dimensions.height10 * 14,
                        width: Dimensions.height10 * 14,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: controller.profileImage == null
                                    ? NetworkImage(controller.userModel!.image)
                                        as ImageProvider
                                    : FileImage(controller.profileImage!))),
                        child: controller.editingProfile
                            ? Container(
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
                                        Colors.black.withOpacity(0.3),
                                        Colors.grey.withOpacity(0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter),
                                ),
                                child: Icon(
                                  size: Dimensions.height10 * 3,
                                  Icons.camera_alt,
                                  color: AppColors.greyColor.withOpacity(0.7),
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    !controller.editingProfile
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.edit();
                                },
                                child: Container(
                                  height: Dimensions.height10 * 4,
                                  width: Dimensions.width10 * 12,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: AppColors.mainColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: Dimensions.width10 * 0.5,
                                      ),
                                      Text(
                                        "Edit Profile",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontSize:
                                                    Dimensions.height10 * 1.5,
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              Text(
                                "HI THERE ${controller.userModel!.name.toUpperCase()}!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: Dimensions.height10 * 2.2),
                              ),
                              SizedBox(
                                height: Dimensions.height10,
                              ),

                            ],
                          )
                        : Container(),
                    SizedBox(height: Dimensions.height10 * 1.6),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.height10,
                      horizontal: Dimensions.width10 * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: Dimensions.height10*0.5,),
                      //fields
                      CustomFormField(
                        margin: EdgeInsets.zero,
                        radius: 5,
                        hintText: controller.userModel!.name,
                        prefixIcon: Icons.person,
                        enabled: controller.editingProfile == true,
                        controller: controller.name,
                        validator: controller.nameValidator,
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: Dimensions.height10 * 0.8,
                ),
                controller.editingProfile
                    ? Column(
                        children: [
                          controller.loading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: AppColors.mainColor,
                                ))
                              : CustomButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await controller.updateUser();
                                      controller.edit();
                                    }
                                  },
                                  buttonText: "Save",
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width10 * 3.6),
                                ),
                          SizedBox(
                            height: Dimensions.height10 * 2.4,
                          ),
                          controller.loading?Container():CustomButton(
                            onPressed: () {
                              controller.edit();
                            },
                            buttonText: "Cancel",
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.width10 * 3.6),
                            transparent: true,
                          ),
                          SizedBox(
                            height: Dimensions.height10 * 2.4,
                          ),
                        ],
                      )
                    : Container(),
                !controller.editingProfile?CustomButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context) => AlertDialog(
                      title: const Text("Are you sure you want to Sign Out ?",style: TextStyle(fontSize: 16),),
                      actions: [
                        TextButton(onPressed: (){
                          Get.back();
                          authController.logOut();
                        }, child: const Text("Yes",style: TextStyle(color: Colors.red),)),
                        TextButton(onPressed: (){
                          Get.back();
                        }, child: const Text("No",style: TextStyle(color: Colors.red),)),
                      ],
                    ),);

                },
                  radius: 10,
                  filledColor: Colors.red,
                  buttonText:"Sign Out" ,
                  height: Dimensions.height10 * 5,
                  width: Dimensions.width10 * 10,
                ):Container()
              ],
            ),
          ),
        );
      },
    );
  }
}
