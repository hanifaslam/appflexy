import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs; // Observable for password visibility
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;
    // Add authentication logic here
    print("Email: $email, Password: $password");
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
