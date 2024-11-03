import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahTiketController extends GetxController {
  // Base URL API Anda
  final String apiUrl =
      'http://10.0.2.2:8000/api/tikets'; // Ganti dengan URL API yang sesuai

  Future<void> tambahTiket(Map<String, dynamic> tiket) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(tiket),
      );

      if (response.statusCode == 201) {
        // Tiket berhasil ditambahkan
        Get.snackbar('Sukses', 'Tiket berhasil ditambahkan!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        // Jika gagal, tampilkan pesan error
        Get.snackbar('Error', 'Gagal menambahkan tiket: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Menangani error
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
