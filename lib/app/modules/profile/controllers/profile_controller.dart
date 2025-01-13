import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  final box = GetStorage();
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var imagePath = ''.obs;

  Future<void> saveProfileToApi() async {
    try {
      var url =
          Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/stores');
      var request = http.MultipartRequest('POST', url);

      // Tambahkan header Authorization
      final token = box.read('token');
      final userId = box.read('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or User ID is missing');
      }

      request.headers['Authorization'] = 'Bearer $token';

      // Debug print
      print('Token: $token');
      print('User ID: $userId');

      request.fields['nama_usaha'] = companyName.value;
      request.fields['jenis_usaha'] = companyType.value;
      request.fields['alamat'] = companyAddress.value;
      request.fields['user_id'] = userId.toString();

      if (imagePath.value.isNotEmpty) {
        try {
          request.files.add(
              await http.MultipartFile.fromPath('gambar', imagePath.value));
        } catch (e) {
          print('Error adding file: $e');
        }
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody'); // Debug print

      var responseData = json.decode(responseBody);

      if (response.statusCode == 201) {
        HomeController.to.fetchCompanyDetails();
        saveToStorage();
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        Get.snackbar(
            'Error', 'Failed to update profile: ${responseData['message']}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  void saveToStorage() {
    // Simpan data yang diperlukan ke storage
    box.write('companyName', companyName.value);
    box.write('companyType', companyType.value);
    box.write('companyAddress', companyAddress.value);
    if (imagePath.value.isNotEmpty) {
      box.write('imagePath', imagePath.value);
    }
  }
}
