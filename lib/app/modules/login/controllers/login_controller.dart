import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var users = <Map<String, dynamic>>[].obs;
  var currentUser = <String, dynamic>{}.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Save token in shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Handle login API request
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/login');

    if (email.isEmpty || password.isEmpty) {
      return {
        'status': 'error',
        'message': 'Email dan password tidak boleh kosong.'
      };
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return await _handleLoginSuccess(response);
      } else {
        return _handleErrorResponse(response);
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Password atau email salah.'};
    }
  }

  // Handle successful login
  Future<Map<String, dynamic>> _handleLoginSuccess(
      http.Response response) async {
    final data = json.decode(response.body);
    if (data['access_token'] != null) {
      final token = data['access_token'];
      await saveToken(token);
      await fetchCurrentUser(token);
      Get.offAllNamed('/profile');
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
    final url = Uri.parse('http://10.0.2.2:8000/api/user');

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

  // Fetch users from the API
  Future<void> fetchUsers() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/users');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        users.value =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        Get.snackbar('Error',
            'Gagal mengambil pengguna. Kode status: ${response.statusCode}',
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
