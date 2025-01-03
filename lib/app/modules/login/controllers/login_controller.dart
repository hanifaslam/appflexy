import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final DaftarKasirController daftarKasirController =
      Get.find<DaftarKasirController>();

  var users = <Map<String, dynamic>>[].obs;
  var currentUser = <String, dynamic>{}.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Save token and user_id in GetStorage
  Future<void> saveTokenAndUserId(String token, int userId) async {
    final box = GetStorage();
    await box.write('token', token);
    await box.write('user_id', userId);
  }

  // Handle login API request
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url =
        Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/login');

    daftarKasirController.clearData();

    if (email.isEmpty || password.isEmpty) {
      return {
        'status': 'error',
        'message': 'Email dan password tidak boleh kosong.'
      };
    }

    showDialog(
        context: Get.context!,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xff181681),),
          );
        });
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.of(Get.context!).pop();
        return await _handleLoginSuccess(response);

      } else {
        Navigator.of(Get.context!).pop();
        return _handleErrorResponse(response);
      }
    } catch (e) {
      Navigator.of(Get.context!).pop();
      return {'status': 'error', 'message': 'Password atau email salah.'};
    }
  }

  // Handle successful login
  Future<Map<String, dynamic>> _handleLoginSuccess(
      http.Response response) async {
    final data = json.decode(response.body);
    if (data['access_token'] != null && data['user_id'] != null) {
      final token = data['access_token'];
      final userId = data['user_id'];
      await saveTokenAndUserId(token, userId);
      await fetchCurrentUser(token);
      // Setelah login berhasil, perbarui data toko
      HomeController.to.fetchCompanyDetails();
      Get.offAllNamed('/home');
      return {'status': 'success', 'message': 'Login successful'};
    } else {
      return {'status': 'error', 'message': 'Respons server tidak valid.'};
    }
  }

  // Handle error response from API
  Map<String, dynamic> _handleErrorResponse(http.Response response) {
    if (response.headers['content-type']?.contains('application/json') ??
        false) {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Email atau password salah.';
      return {'status': 'error', 'message': errorMessage};
    } else {
      return {
        'status': 'error',
        'message': 'Format respons tidak terduga dari server.'
      };
    }
  }

  // Fetch current user data from the API
  Future<void> fetchCurrentUser(String token) async {
    final url =
        Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        if (userData != null) {
          currentUser.value = userData;
        } else {
          Get.snackbar('Error', 'Data pengguna kosong.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3));
        }
      } else {
        Get.snackbar('Error',
            'Gagal mengambil data pengguna. Kode status: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }
}
