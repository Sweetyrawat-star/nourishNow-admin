import 'package:admin/modules/auth/controllers/login_controller.dart';
import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:admin/shared/widgets/custom_button.dart';
import 'package:admin/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    LogInController controller = Get.find<LogInController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: Dimensions.height10 * 3.6),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: Dimensions.height10 * 3,
                      color: AppColors.mainColor),
                ),
                Image.asset("assets/images/Logo12.png",height: Dimensions.height10*20,),

                Text(
                  "Add your details to login",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: Dimensions.height10 * 1.5,
                      color: AppColors.textColor),
                ),
                SizedBox(height: Dimensions.height10 * 3),
                CustomFormField(
                    hintText: "Your email",
                    prefixIcon: Icons.email,
                    controller: controller.email,
                    isEmail: true,
                    validator: controller.emailValidator),
                SizedBox(
                  height: Dimensions.height10 * 2.8,
                ),
                CustomFormField(
                    hintText: "Password",
                    prefixIcon: Icons.lock,
                    isPassword: true,
                    controller: controller.password,
                    validator: controller.passwordValidator),
                SizedBox(
                  height: Dimensions.height10*4.5,
                ),
                //loginButton
                GetBuilder<LogInController>(builder: (controller) {
                  return controller.loading == true
                      ? Center(
                          child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ))
                      : CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              controller.logIn(
                                  email: controller.email.text,
                                  password: controller.password.text);
                            }
                          },
                          buttonText: "Login",
                          margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10 * 3.6),
                        );
                }),
                SizedBox(
                  height: Dimensions.height10 * 2.8,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
