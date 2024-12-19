import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:convert';

class PengaturanProfileController extends GetxController {
  var companyLogo = ''.obs;
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStoreData(); // Fetch store data when controller is initialized
  }

  // Fetch store data from the API
  Future<void> fetchStoreData() async {
    try {
      isLoading.value = true;
      final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/stores'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Assuming the API returns the first store's details
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
          'Failed to load store data',
          backgroundColor: const Color(0xFF5C8FDA).withOpacity(0.2),
          colorText: const Color(0xFF2B47CA),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: const Color(0xFF5C8FDA).withOpacity(0.2),
        colorText: const Color(0xFF2B47CA),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update store data including logo upload
  Future<void> updateStore() async {
    try {
      isLoading.value = true;

      // Prepare multipart request for file upload
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8000/api/stores/update'));

      // Add text fields
      request.fields['nama_usaha'] = companyName.value;
      request.fields['bidang_usaha'] = companyType.value;
      request.fields['alamat'] = companyAddress.value;

      // Add logo file if a new image is selected
      if (companyLogo.value.isNotEmpty &&
          File(companyLogo.value).existsSync()) {
        var file = File(companyLogo.value);
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();

        var multipartFile = http.MultipartFile('gambar', stream, length,
            filename: path.basename(file.path));

        request.files.add(multipartFile);
      }

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        // Read and parse the response
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);

        Get.snackbar(
          'Sukses',
          responseData['message'] ?? 'Profil toko berhasil diperbarui',
          backgroundColor: Colors.green.withOpacity(0.2),
          colorText: Colors.green,
        );

        // Optionally refresh the data
        await fetchStoreData();
      } else {
        Get.snackbar(
          'Error',
          'Gagal memperbarui profil toko',
          backgroundColor: const Color(0xFF5C8FDA).withOpacity(0.2),
          colorText: const Color(0xFF2B47CA),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: const Color(0xFF5C8FDA).withOpacity(0.2),
        colorText: const Color(0xFF2B47CA),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
