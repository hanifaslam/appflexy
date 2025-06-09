import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final DaftarKasirController daftarKasirController =
      Get.find<DaftarKasirController>();

  var users = <Map<String, dynamic>>[].obs;
  var currentUser = <String, dynamic>{}.obs;
  
  // Login timeout duration in seconds
  final int loginTimeoutDuration = 15;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Method to clear all text fields
  void clearAllFields() {
    emailController.clear();
    passwordController.clear();
  }

  // Method to clear individual fields
  void clearEmailField() {
    emailController.clear();
  }

  void clearPasswordField() {
    passwordController.clear();
  }

  // Method to reset form state
  void resetForm() {
    clearAllFields();
    isPasswordHidden.value = true;
    isLoading.value = false;
  }

  // Save token and user_id in GetStorage
  Future<void> saveTokenAndUserId(String token, int userId) async {
    final box = GetStorage();
    await box.write('token', token);
    await box.write('user_id', userId);
  }
  // Handle login API request
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Validate inputs first
    if (email.isEmpty) {
      _showErrorSnackbar('Email Kosong', 'Email harus diisi!');
      return {'status': 'error', 'message': 'Email kosong'};
    }

    if (password.isEmpty) {
      _showErrorSnackbar('Password Kosong', 'Password harus diisi!');
      return {'status': 'error', 'message': 'Password kosong'};
    }
    
    // Email validation
    if (!_isValidEmail(email)) {
      _showErrorSnackbar('Format Email Salah', 'Masukkan format email yang benar');
      return {'status': 'error', 'message': 'Format email tidak valid'};
    }

    // Set loading state
    isLoading.value = true;
    final url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.login));

    daftarKasirController.clearData();
    
    try {
      // Create a timeout that will trigger if the request takes too long
      final responseCompleter = Completer<http.Response>();
      
      // Setup timeout
      Future.delayed(Duration(seconds: loginTimeoutDuration), () {
        if (!responseCompleter.isCompleted) {
          responseCompleter.completeError(TimeoutException('Login request timed out'));
        }
      });
      
      // Make the actual request
      http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).then((response) {
        if (!responseCompleter.isCompleted) {
          responseCompleter.complete(response);
        }
      }).catchError((error) {
        if (!responseCompleter.isCompleted) {
          responseCompleter.completeError(error);
        }
      });
      
      // Wait for either the response or the timeout
      final response = await responseCompleter.future;
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle the response based on status code
      if (response.statusCode == 200) {
        isLoading.value = false;
        return await _handleLoginSuccess(response);
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        isLoading.value = false;
        _showErrorSnackbar('Login Gagal', 'Email atau password salah.');
        return {'status': 'error', 'message': 'Kredensial tidak valid'};
      } else if (response.statusCode == 404) {
        isLoading.value = false;
        _showErrorSnackbar('Server Error', 'Tidak dapat terhubung ke server.');
        return {'status': 'error', 'message': 'Tidak dapat terhubung ke server.'};
      } else {
        isLoading.value = false;
        return _handleErrorResponse(response);
      }
    } on TimeoutException catch (_) {
      isLoading.value = false;
      _showErrorSnackbar('Timeout', 'Waktu permintaan habis. Server tidak merespon.');
      return {'status': 'error', 'message': 'Timeout pada server'};
    } catch (e) {
      isLoading.value = false;
      _showErrorSnackbar('Error', 'Terjadi kesalahan koneksi: ${e.toString()}');
      return {'status': 'error', 'message': 'Kesalahan koneksi'};
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

      // Show a brief success message
      _showSuccessSnackbar('Login Berhasil', 'Selamat datang kembali!');
      
      // Navigate to appropriate page
      if (isRegistered) {
        Get.offAllNamed(Routes.HOME);
      } else {
        HomeController.to.fetchCompanyDetails();
        Get.offAllNamed(Routes.HOME);
      }
      return {'status': 'success', 'message': 'Login successful'};
    } else {
      _showErrorSnackbar('Error', 'Respons server tidak valid.');
      return {'status': 'error', 'message': 'Respons server tidak valid.'};
    }
  }
  // Handle error response from API
  Map<String, dynamic> _handleErrorResponse(http.Response response) {
    if (response.headers['content-type']?.contains('application/json') ??
        false) {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['message'] ?? 'Terjadi kesalahan pada server';
      
      // Show appropriate message based on error
      if (errorMessage.toLowerCase().contains('email') || 
          errorMessage.toLowerCase().contains('password')) {
        _showErrorSnackbar('Login Gagal', 'Email atau password salah.');
      } else {
        _showErrorSnackbar('Error', errorMessage);
      }
      
      return {'status': 'error', 'message': errorMessage};
    } else {
      _showErrorSnackbar('Login Gagal', 'Email atau password salah.');
      return {'status': 'error', 'message': 'Email atau password salah.'};
    }
  }
  // Fetch current user data from the API
  Future<void> fetchCurrentUser(String token) async {
    final url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.users));

    try {
      // Set a timeout for this request too
      final responseCompleter = Completer<http.Response>();
      
      // Setup timeout
      Future.delayed(Duration(seconds: loginTimeoutDuration), () {
        if (!responseCompleter.isCompleted) {
          responseCompleter.completeError(TimeoutException('User data request timed out'));
        }
      });
      
      // Make the actual request
      http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).then((response) {
        if (!responseCompleter.isCompleted) {
          responseCompleter.complete(response);
        }
      }).catchError((error) {
        if (!responseCompleter.isCompleted) {
          responseCompleter.completeError(error);
        }
      });
      
      // Wait for either the response or the timeout
      final response = await responseCompleter.future;

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        if (userData != null) {
          currentUser.value = userData;
        } else {
          // Just log the error, don't show to user during login flow
          print('Error: Data pengguna kosong.');
        }
      } else {
        print('Error: Gagal mengambil data pengguna. Kode status: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      print('Timeout saat mengambil data pengguna');
    } catch (e) {
      print('Error saat mengambil data pengguna: $e');
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
      }      await box.remove('store_id');
      return false;
    } catch (e) {
      print('Error checking store: $e');
      return false;
    }
  }
  
  // Helper method to show error snackbars consistently
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: Icon(Icons.error_outline, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade800,
      colorText: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
  
  // Show success snackbar
  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
    // Email validation using regex
  bool _isValidEmail(String email) {
    // Simple email validation regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
    @override
  void onClose() {
    // Safely dispose TextEditingControllers
    try {
      emailController.dispose();
      passwordController.dispose();
    } catch (e) {
      print('Error disposing controllers: $e');
    }
    super.onClose();
  }
}
