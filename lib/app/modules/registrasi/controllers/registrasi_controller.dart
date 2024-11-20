import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrasiController extends GetxController {
  // Controllers for the text fields
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  // Observables for password visibility
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Method to toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Method to handle registration logic
  Future<void> register() async {
    // Get the input values
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validation checks
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'All fields are required', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check if password is strong enough (optional)
    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters long', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Proceed with registration logic (e.g., API call)
    print('User registered with email: $email');

    // Example of API call for registration
    // var response = await api.register(email, password);

    // Handle the response (successful registration, etc.)
    // For now, show a success message
    Get.snackbar('Success', 'Registration successful', snackPosition: SnackPosition.BOTTOM);

    // Optionally, navigate to the next screen after successful registration
    // Get.toNamed(Routes.LOGIN); // If you want to navigate to login screen
  }
}