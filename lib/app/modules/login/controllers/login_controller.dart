import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

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
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email harus diisi!.',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
          duration: const Duration(seconds: 3));
      return {
        'status': 'error',
      };
    }

    if (password.isEmpty) {
      Get.snackbar('Error', 'Password harus diisi!.',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
          duration: const Duration(seconds: 3));
      return {
        'status': 'error',
      };
    }

    final url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.login));

    daftarKasirController.clearData();

    showDialog(
        context: Get.context!,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xff181681),
            ),
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
      } else if (response.statusCode == 404) {
        Navigator.of(Get.context!).pop();
        Get.snackbar(
          'Error',
          'Tidak dapat terhubung ke server.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return {
          'status': 'error',
          'message': 'Tidak dapat terhubung ke server.'
        };
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

      final box = GetStorage();
      final isRegistered = box.read('isRegistered') ?? false;

      // Hanya set needsProfile ke true jika user belum terdaftar
      if (!isRegistered) {
        await box.write('needsProfile', true);
      } else {
        await box.write(
            'needsProfile', false); // User sudah terdaftar, langsung ke home
      }

      if (isRegistered) {
        Get.offAllNamed(Routes.HOME);
      } else {
        HomeController.to.fetchCompanyDetails();
        Get.offAllNamed(Routes.HOME);
      }
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
      final errorMessage = errorData['message'];
      return {'status': 'error', 'message': errorMessage};
    } else {
      Get.snackbar('Error', 'Email atau password salah.',
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3));
      return {'status': 'error', 'message': 'Email atau password salah.'};
    }
  }

  // Fetch current user data from the API
  Future<void> fetchCurrentUser(String token) async {
    final url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.users));

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
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 3));
        }
      } else {
        Get.snackbar('Error',
            'Gagal mengambil data pengguna. Kode status: ${response.statusCode}',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3));
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3));
    }
  }

  Future<bool> checkStoreExists(String token, int userId) async {
    try {
      final box = GetStorage();      final response = await http.get(
        Uri.parse(ApiConstants.getMainUrl('api/stores/user/$userId')),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['id'] != null) {
          box.write('store_id', data['id']);
          return true;
        }
      }
      await box.remove('store_id');
      return false;
    } catch (e) {
      print('Error checking store: $e');
      return false;
    }
  }
}
