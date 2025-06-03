import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apptiket/app/core/constants/api_constants.dart';

class TambahTiketController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Getter untuk token
  String? get token => box.read('token');

  // Function to add a new ticket
  Future<bool> addTiket(Map<String, dynamic> tiketData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(ApiConstants.getFullUrl(ApiConstants.tikets)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(tiketData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success snackbar
        Get.snackbar(
          'Berhasil',
          'Tiket berhasil ditambahkan!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        return true;
      } else {
        // Error response
        final errorData = json.decode(response.body);
        final errorMsg = errorData['message'] ?? 'Gagal menambahkan tiket';
        errorMessage.value = errorMsg;
        
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        return false;
      }
    } catch (e) {
      print('Error adding tiket: $e');
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menambahkan tiket',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTiket(int id, Map<String, dynamic> tiketData) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.put(
        Uri.parse(ApiConstants.getFullUrl('${ApiConstants.tikets}/$id')),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(tiketData),
      );

      if (response.statusCode == 200) {
        // Success snackbar
        Get.snackbar(
          'Berhasil',
          'Tiket berhasil diupdate!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        return true;
      } else {
        // Error response
        final errorData = json.decode(response.body);
        final errorMsg = errorData['message'] ?? 'Gagal mengupdate tiket';
        errorMessage.value = errorMsg;
        
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        return false;
      }
    } catch (e) {
      print('Error updating tiket: $e');
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengupdate tiket',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
