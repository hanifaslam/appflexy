import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GantiPasswordController extends GetxController {
  final box = GetStorage();
  var passwordLama = ''.obs;
  var passwordBaru = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  var isPasswordLamaVisible = false.obs;
  var isPasswordBaruVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void togglePasswordLamaVisibility() => isPasswordLamaVisible.toggle();
  void togglePasswordBaruVisibility() => isPasswordBaruVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  // Add TextEditingControllers
  final passwordLamaController = TextEditingController();
  final passwordBaruController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? getToken() => box.read('token');
  int? getUserId() => box.read('user_id');

  @override
  void onClose() {
    passwordLamaController.dispose();
    passwordBaruController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void clearFields() {
    passwordLama.value = '';
    passwordBaru.value = '';
    confirmPassword.value = '';
    passwordLamaController.clear();
    passwordBaruController.clear();
    confirmPasswordController.clear();
  }

  Future<void> gantiPassword() async {
    if (passwordBaru.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password baru tidak sesuai!');
      return;
    }

    if (passwordLama.value.isEmpty || passwordBaru.value.isEmpty) {
      Get.snackbar('Error', 'Isi semua password terlebih dahulu!');
      return;
    }

    try {
      isLoading(true);
      final token = getToken();
      final userId = getUserId();

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final response = await http.post(
        Uri.parse(
            'https://cheerful-distinct-fox.ngrok-free.app/api/change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': passwordLama.value,
          'new_password': passwordBaru.value,
          'user_id': userId,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        clearFields();
        Get.snackbar(
          'Sukses',
          'Password berhasil diubah',
          backgroundColor: Colors.green.withOpacity(0.4),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          borderRadius: 10,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        );
        await Future.delayed(Duration(seconds: 2));
        Get.back();
      } else {
        throw Exception(data['message'] ?? 'Gagal mengubah password');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception:', ''));
    } finally {
      isLoading(false);
    }
  }
}
