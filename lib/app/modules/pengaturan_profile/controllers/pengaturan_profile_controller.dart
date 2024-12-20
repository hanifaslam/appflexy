import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PengaturanProfileController extends GetxController {
  var companyLogo = ''.obs;
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStoreData(); // Ambil data saat controller diinisialisasi
  }

  // Fetch data toko dari API
  Future<void> fetchStoreData() async {
    try {
      isLoading.value = true;
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/stores'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final store = data[0];
          companyLogo.value = store['gambar'] ?? '';
          companyName.value = store['nama_usaha'] ?? '';
          companyType.value = store['bidang_usaha'] ?? '';
          companyAddress.value = store['alamat'] ?? '';
        }
      } else {
        Get.snackbar(
          'Error',
          'Gagal memuat data toko',
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update data toko
  Future<void> updateStore() async {
    try {
      isLoading.value = true;
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8000/api/stores/update'));

      request.fields['nama_usaha'] = companyName.value;
      request.fields['bidang_usaha'] = companyType.value;
      request.fields['alamat'] = companyAddress.value;

      if (companyLogo.value.isNotEmpty &&
          File(companyLogo.value).existsSync()) {
        var file = File(companyLogo.value);
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();

        var multipartFile = http.MultipartFile('gambar', stream, length,
            filename: path.basename(file.path));
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);

        Get.snackbar(
          'Sukses',
          responseData['message'] ?? 'Profil toko berhasil diperbarui',
          backgroundColor: Colors.green.withOpacity(0.2),
          colorText: Colors.green,
        );

        await fetchStoreData();
      } else {
        Get.snackbar(
          'Error',
          'Gagal memperbarui profil toko',
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
