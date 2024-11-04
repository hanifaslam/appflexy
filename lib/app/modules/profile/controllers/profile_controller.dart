import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final box = GetStorage();

class ProfileController extends GetxController {
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var companyLogoPath = ''.obs; // Untuk menyimpan path logo toko

  // Fungsi untuk menyimpan nama toko
  void setCompanyName(String name) {
    companyName.value = name;
  }

  // Fungsi untuk menyimpan bidang usaha
  void setCompanyType(String type) {
    companyType.value = type;
  }

  // Fungsi untuk menyimpan alamat toko
  void setCompanyAddress(String address) {
    companyAddress.value = address;
  }

  // Fungsi untuk menyimpan logo toko
  void setCompanyLogo(String path) {
    companyLogoPath.value = path; // Path gambar yang dipilih
  }

  // Simpan data ke GetStorage
  void saveToStorage() {
    box.write('companyName', companyName.value);
    box.write('companyType', companyType.value);
    box.write('companyAddress', companyAddress.value);
    box.write('companyLogo', companyLogoPath.value);
  }

  // Baca data dari GetStorage
  void loadFromStorage() {
    companyName.value = box.read('companyName') ?? '';
    companyType.value = box.read('companyType') ?? '';
    companyAddress.value = box.read('companyAddress') ?? '';
    companyLogoPath.value = box.read('companyLogo') ?? '';
  }

  @override
  void onInit() {
    loadFromStorage();
    super.onInit();
  }

  Future<void> saveProfileToApi() async {
    try {
      var url = Uri.parse(
          'http://10.0.2.2:8000/api/stores'); // Ganti dengan URL API Anda
      var request = http.MultipartRequest('POST', url);

      // Tambahkan field ke dalam request dengan nama yang sesuai
      request.fields['nama_usaha'] =
          companyName.value; // Ganti dengan nama_usaha
      request.fields['jenis_usaha'] =
          companyType.value; // Ganti dengan jenis_usaha
      request.fields['alamat'] = companyAddress.value; // Ganti dengan alamat

      // Jika pengguna memilih logo, tambahkan ke request sebagai file
      if (companyLogoPath.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'gambar', // Nama field untuk file logo di API
          companyLogoPath.value,
        ));
      }

      // Kirim request ke API
      var response = await request.send();

      // Cek apakah request berhasil
      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);
        Get.snackbar('Success', 'Profile updated successfully!');
      } else {
        // Tambahkan ini untuk menangkap respons error
        var responseBody = await response.stream.bytesToString();
        Get.snackbar('Error',
            'Failed to update profile. Status: ${response.statusCode}, Response: $responseBody');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred. Please try again.');
      print(e);
    }
  }
}
