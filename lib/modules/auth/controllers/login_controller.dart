import 'package:admin/data/auth_repository/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LogInController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();

  String?  emailValidator(String? value){
    if(value!.isEmpty||!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w]{2,}').hasMatch(value)){
      return "Enter correct email";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r'^(?=.*[0-9a-zA-Z]).{6,}$').hasMatch(value)) {
      return "Enter correct password";
    }
    return null;
  }

  bool loading=false;


  Future<void> logIn({required email, required password})  async {
    loading=true;
    update();
     await AuthenticationRepository.instance
        .loginWithEmailAndPassword(email, password);
    loading=false;
    update();
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    email.dispose();
    password.dispose();
  }
}
