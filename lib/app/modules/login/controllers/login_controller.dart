import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var users = <Map<String, dynamic>>[].obs; // Observable list to hold users
  var currentUser =
      <String, dynamic>{}.obs; // Observable map to hold current user data

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Function to save token in shared preferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Function to handle login API request
  Future<void> login(String email, String password) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/login');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debugging response body

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          var data = json.decode(response.body);
          String token = data['access_token']; // Ensure you use 'access_token'

          await saveToken(token);
          await fetchCurrentUser(token);
          Get.offAllNamed('/profile');
        } else {
          Get.snackbar('Error', 'Expected JSON, but received something else.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3));
        }
      } else {
        handleErrorResponse(response);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  // Function to handle error response from API
  void handleErrorResponse(http.Response response) {
    if (response.headers['content-type']?.contains('application/json') ??
        false) {
      var errorData = json.decode(response.body);
      String errorMessage =
          errorData['error'] ?? 'Login failed. Please try again.';
      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } else {
      Get.snackbar('Error', 'Unexpected response format: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  // Function to fetch current user data from the API
  Future<void> fetchCurrentUser(String token) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/user');

    try {
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check response status from the API
      if (response.statusCode == 200) {
        var userData = json.decode(response.body);
        if (userData != null) {
          currentUser.value = userData; // Pastikan userData tidak null
        } else {
          Get.snackbar('Error', 'User data is null.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3));
        }
      } else {
        Get.snackbar('Error',
            'Failed to fetch user data. Status code: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  // Function to fetch users from the API
  Future<void> fetchUsers() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/users');

    try {
      var response = await http.get(url);

      // Check response status from the API
      if (response.statusCode == 200) {
        users.value =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        Get.snackbar('Error',
            'Failed to fetch users. Status code: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }
}
