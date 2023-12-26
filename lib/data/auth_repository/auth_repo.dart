import 'package:admin/models/signup_model.dart';
import 'package:admin/modules/auth/bindings/login_bindings.dart';
import 'package:admin/modules/auth/views/login_screen.dart';
import 'package:admin/modules/home/controllers/home_controller.dart';
import 'package:admin/modules/layout/bindings/bindings.dart';
import 'package:admin/modules/layout/controllers/layout_controller.dart';
import 'package:admin/modules/layout/views/layout.dart';
import 'package:admin/modules/profile_screen/controllers/profile_controller.dart';
import 'package:admin/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    //get the current user
    firebaseUser = Rx<User?>(_auth.currentUser);
    //get the latest update
    firebaseUser.bindStream(_auth.userChanges());
    _setInitialScreen(firebaseUser);

  }

  void _setInitialScreen(Rx<User?> user) {
    if(user.value == null)
    {
      Get.offAll(const LoginScreen(),binding: LoginBindings(), transition: Transition.rightToLeft);
    }
    else{
      AppConstants.uid=user.value!.uid;
      Get.offAll(const HomeLayOutScreen(),binding: LayOutBindings(), transition: Transition.rightToLeft);
    }

  }




  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser.value != null) {
        AppConstants.uid = firebaseUser.value!.uid;
        await userCreate(uid: AppConstants.uid);
        Get.offAll(const HomeLayOutScreen(),binding: LayOutBindings(), transition: Transition.rightToLeft);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('EXCEPTION - ${e.message}');

    } catch (value) {
      debugPrint(value.toString());
    }
  }


  Future<void> userCreate(
      {
        required String uid,
        String? image}) async {
    SignUpModel model = SignUpModel(
      name: "admin",
      image: image ??
          "https://cdn-icons-png.flaticon.com/512/727/727399.png?w=740&t=st=1679753400~exp=1679754000~hmac=adf67891bf997c1bce60aad53598bc292eeaf6456fe99fdde4012e8dabd60e0d",
    );

    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!docSnapshot.exists) {
      // Document exists
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(model.toMap())
          .then((value) {})
          .catchError((error) {
        debugPrint(error.toString());
      });
    }

  }

  Future<void> logOut() async {
    try{
      await _auth.signOut();
      Get.delete<ProfileController>(force: true);
      Get.delete<LayoutController>(force: true);
      Get.delete<HomeController>(force: true);
      Get.offAll(const LoginScreen(),transition: Transition.rightToLeft,binding: LoginBindings());

    }catch(e){
      debugPrint(e.toString());
    }

  }

}
