import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:apptiket/app/core/constants/api_constants.dart';

class StorageKeys {
  static const String token = 'token';
  static const String userId = 'user_id';
  static const String isProfileComplete = 'is_profile_complete';
}

// Modify your ProfileController
class ProfileController extends GetxController {
  final box = GetStorage();
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var imagePath = ''.obs;
  Future<void> saveProfileToApi() async {
    try {
      var url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.stores));
      var request = http.MultipartRequest('POST', url);

      final token = box.read(StorageKeys.token);
      final userId = box.read(StorageKeys.userId);

      if (token == null || userId == null) {
        throw Exception('Token or User ID is missing');
      }

      request.headers['Authorization'] = 'Bearer $token';

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
      var responseData = json.decode(responseBody);

      if (response.statusCode == 201) {
        // Mark profile as complete
        box.remove('needsProfile');
        HomeController.to.fetchCompanyDetails();
        saveToStorage();
        Get.snackbar('Success', 'Profile updated successfully!');
        Get.offAllNamed(Routes.HOME); // Navigate to home after success
      } else {
        Get.snackbar(
            'Error', 'Failed to update profile: ${responseData['message']}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Add method to check if profile is complete
  bool isProfileComplete() {
    return box.read(StorageKeys.isProfileComplete) ?? false;
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
