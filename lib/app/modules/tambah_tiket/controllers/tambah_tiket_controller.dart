import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahTiketController extends GetxController {
  final box = GetStorage();
  final DaftarKasirController daftarKasirController = Get.find();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> addTiket(Map<String, dynamic> tiketData) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/tikets'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(tiketData),
    );

    showDialog(
        context: Get.context!,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xff181681),),
          );
        });

    // check if the response status code is 201
    if (response.statusCode == 201) {
      daftarKasirController.fetchTiketList(); // Refresh daftar tiket
      Get.snackbar('Sukses', 'Tiket berhasil ditambahkan!',
          colorText: Colors.black.withOpacity(0.8),
          barBlur: 15,
          icon: Icon(Icons.check, color: Colors.green,),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
      Navigator.of(Get.context!).pop();
    } else {
      errorMessage.value = 'Gagal menambahkan tiket: ${response.body}';
      Get.snackbar('Error', errorMessage.value,
          colorText: Colors.black.withOpacity(0.8),
          barBlur: 15,
          icon: Icon(Icons.error, color: Colors.red,),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP);
      Navigator.of(Get.context!).pop();
    }
    isLoading.value = false;
  }

  Future<void> updateTiket(int id, Map<String, dynamic> tiketData) async {
    isLoading.value = true;
    final response = await http.put(
      Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/tikets/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(tiketData),
    );

    showDialog(
        context: Get.context!,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xff181681),),
          );
        });

    if (response.statusCode == 200) {
      daftarKasirController.fetchTiketList(); // Refresh daftar tiket
      Get.snackbar('Sukses', 'Tiket berhasil diperbarui!',
          colorText: Colors.black.withOpacity(0.8),
          barBlur: 15,
          icon: Icon(Icons.check, color: Colors.green,),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP);
      Navigator.of(Get.context!).pop();
    } else {
      errorMessage.value = 'Gagal mengupdate tiket: ${response.body}';
      Get.snackbar('Error', errorMessage.value,
          colorText: Colors.black.withOpacity(0.8),
          barBlur: 15,
          icon: Icon(Icons.error, color: Colors.red,),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP);
      Navigator.of(Get.context!).pop();
    }
    isLoading.value = false;
  }
}
