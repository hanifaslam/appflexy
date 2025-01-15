import 'package:apptiket/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profileuser2Controller extends GetxController {
  final box = GetStorage();

  // Observable for company details
  var companyName = ''.obs;
  var companyLogo = ''.obs; // Path for logo

  @override
  void onInit() {
    super.onInit();
    fetchCompanyDetails();
  }

  // Fetch company details from the API
  Future<void> fetchCompanyDetails() async {
    try {
      final response =
          await http.get(Uri.parse('https://flexy.my.id/api/stores'));

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        print('Fetched store data: $responseData'); // Debug print

        if (responseData is Map<String, dynamic> &&
            responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          final userId = box.read('user_id').toString();
          final userStore = data.firstWhere(
            (store) => store['user_id'].toString() == userId,
            orElse: () => null,
          );

          if (userStore != null) {
            companyName.value =
                userStore['nama_usaha'] ?? 'Nama tidak ditemukan';
            companyLogo.value = userStore['gambar'] ?? '';
          } else {
            companyName.value = 'Nama tidak ditemukan';
            companyLogo.value = '';
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load store details');
      }
    } catch (e) {
      print('Error fetching store details: $e');
      Get.snackbar('Error', 'Failed to load store details');
    }
  }

  // Function to update company name
  void setCompanyName(String name) {
    companyName.value = name;
    box.write('companyName', name);
    Get.snackbar('Perubahan Disimpan', 'Nama perusahaan berhasil diperbarui');
  }

  // Function to update company logo
  void setCompanyLogo(String logoPath) {
    companyLogo.value = logoPath;
    box.write('companyLogo', logoPath);
    Get.snackbar('Perubahan Disimpan', 'Logo perusahaan berhasil diperbarui');
  }

  // Function to get logo file path
  String getLogoFilePath() {
    return companyLogo.value.isEmpty
        ? 'assets/images/default_logo.png' // Default logo if none
        : companyLogo.value; // Logo path from storage
  }

  void logout() {
    box.remove('token');
    box.remove('user_id');
    Get.offAllNamed(Routes.LOGIN);
  }

  // Function to get token
  String getToken() {
    return box.read('token') ?? '';
  }
}
