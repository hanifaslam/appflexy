import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class RegistrasiController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Method to toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> register(String email, String password, String confirmPassword,
      String name) async {
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty) {
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Invalid email address.');
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters.');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Password confirmation does not match.');
      return;
    }

    isLoading(true);
    try {
      var url = Uri.parse(
          'https://cheerful-distinct-fox.ngrok-free.app/api/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        var token = data['access_token'];
        var userId = data['user_id'];

        // Simpan token dan user_id ke storage
        box.write('token', token);
        box.write('user_id', userId);

        print('Token: $token');
        print('User ID: $userId');

        Get.snackbar('Success', 'Registration successful!');

        // Refresh data in DaftarKasirController
        final daftarKasirController = Get.find<DaftarKasirController>();
        daftarKasirController.refreshData();

        // Arahkan ke halaman profil toko
        Get.offNamed(
            Routes.PROFILE); // Pastikan Anda memiliki route yang sesuai
      } else {
        var errorData = json.decode(response.body);
        Get.snackbar('Error', 'Registration failed: ${errorData.toString()}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
