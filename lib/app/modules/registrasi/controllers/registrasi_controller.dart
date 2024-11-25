import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrasiController extends GetxController {
  // Controllers for the text fields
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  // Observables for password visibility
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // Observable for loading state
  var isLoading = false.obs;

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
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validation checks
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Semua kolom wajib diisi',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Masukkan alamat email yang valid',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Kata sandi tidak cocok',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Check if password is strong enough
    if (password.length < 8) {
      Get.snackbar('Error', 'Kata sandi minimal 8 karakter',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Set loading state
    isLoading.value = true;

    try {
      // Buat request ke API register
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:8000/api/register'), // Ganti dengan URL API Anda
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      // Periksa response dari server
      if (response.statusCode == 201) {
        // Parsing token dari response
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String accessToken = responseData['access_token'];

        // Tampilkan pesan sukses
        Get.snackbar('Sukses', 'Registrasi berhasil',
            snackPosition: SnackPosition.BOTTOM);

        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        Get.offAllNamed('/login');

      } else {
        // Tangani error dari server
        final Map<String, dynamic> errorData = json.decode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Registrasi gagal',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Tangani error koneksi atau server
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
