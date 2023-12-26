import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpFailure{
  final String message;

  SignUpFailure([this.message = "An Unknown error occurred"]);

  factory SignUpFailure.code(String code){
    switch(code){
      case 'weak-password' :
        return SignUpFailure('Please enter a stronger password.');
      case 'invalid-email' :
        Get.snackbar("Error", 'Email is not valid or badly formatted.',colorText: Colors.red);
        return SignUpFailure('Email is not valid or badly formatted.');

      case 'email-already-in-use' :

        return SignUpFailure('An account already exist for that email.');

      case 'operation-not-allowed' :
        return SignUpFailure('Operation is not allowed. Please contact support.');
      case 'user-disabled' :
        return SignUpFailure('This user has been disabled. Please contact support for help.');
      case 'network-request-failed':
        Get.snackbar("Error", 'Please check your network connection.',colorText: Colors.red);
        return SignUpFailure('There was a problem with your network connection. Please try again later.');
      case 'user-not-found':
        Get.snackbar("Error", "The user account associated with the email you entered does not exist. Please sign up first.",colorText: Colors.red);

        return SignUpFailure('The user account associated with the email you entered does not exist. Please sign up first.');
      default: return SignUpFailure();
    }
  }
}