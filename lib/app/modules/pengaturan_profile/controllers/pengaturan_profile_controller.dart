import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:apptiket/app/core/constants/api_constants.dart';

class PengaturanProfileController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var companyLogo = ''.obs;
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var selectedImage = Rxn<File>();

  String? getToken() => box.read('token');
  int? getUserId() => box.read('user_id');

  @override
  void onInit() {
    super.onInit();
    fetchStoreData();
  }

  Future<void> fetchStoreData() async {
    try {
      isLoading.value = true;
      final token = getToken();
      final userId = getUserId();

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse('https://flexy.my.id/api/stores'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          final userStore = data['data'].firstWhere(
            (store) => store['user_id'] == userId,
            orElse: () => null,
          );

          if (userStore != null) {
            box.write('store_id', userStore['id']); // Save store_id
            companyLogo.value = userStore['gambar'] ?? '';
            companyName.value = userStore['nama_usaha'] ?? '';
            companyType.value = userStore['jenis_usaha'] ?? '';
            companyAddress.value = userStore['alamat'] ?? '';
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStore() async {
    try {
      isLoading.value = true;
      final token = getToken();
      final userId = getUserId();
      final storeId = box.read('store_id');

      print('Updating store with ID: $storeId');
      print('User ID: $userId');
      print('Company Name: ${companyName.value}');
      print('Company Type: ${companyType.value}');
      print('Company Address: ${companyAddress.value}');

      if (token == null || userId == null || storeId == null) {
        throw Exception('Authentication required or store_id not found');
      }

      var request = http.MultipartRequest(
        'POST', // Change to POST
        Uri.parse('https://flexy.my.id/api/stores/$storeId'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields.addAll({
        '_method': 'PUT', // Add this for Laravel to handle as PUT
        'nama_usaha': companyName.value,
        'jenis_usaha': companyType.value,
        'alamat': companyAddress.value,
        'user_id': userId.toString(),
      });

      if (selectedImage.value != null) {
        print('Adding image file: ${selectedImage.value!.path}');
        var imageFile = await http.MultipartFile.fromPath(
          'gambar',
          selectedImage.value!.path,
        );
        request.files.add(imageFile);
      }

      print('Request fields: ${request.fields}');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      showDialog(
          context: Get.context!,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xff181681),
              ),
            );
          });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          Get.snackbar(
            'Sukses',
            'Profil toko berhasil diperbarui',
            backgroundColor: Colors.green.withOpacity(0.2),
            colorText: Colors.green,
          );
          await fetchStoreData();
          Navigator.of(Get.context!).pop();
        } else {
          throw Exception(responseData['message'] ?? 'Update failed');
        }
      } else {
        var errorMessage = 'Gagal memperbarui data';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['errors'] != null) {
            errorMessage = errorData['errors'].values.join('\n');
          }
        } catch (e) {
          print('Error parsing error response: $e');
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error updating store: $e');
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
