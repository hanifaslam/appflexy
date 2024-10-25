import 'package:get/get.dart';

class PengaturanProfileController extends GetxController {
  // Observable properties for company details
  var companyLogo = ''.obs;        // Path untuk logo perusahaan
  var companyName = ''.obs;        // Nama perusahaan
  var companyType = ''.obs;        // Bidang usaha
  var companyAddress = ''.obs;     // Alamat perusahaan

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data jika diperlukan
  }

  @override
  void onReady() {
    super.onReady();
    // Dapatkan data yang diperlukan saat kontroller siap
  }

  @override
  void onClose() {
    super.onClose();
    // Lakukan pembersihan jika diperlukan
  }

  // Method untuk mengatur logo perusahaan
  void setCompanyLogo(String logoPath) {
    companyLogo.value = logoPath;  // Set path logo perusahaan
  }

  // Method untuk mengatur nama perusahaan
  void setCompanyName(String name) {
    companyName.value = name;       // Set nama perusahaan
  }

  // Method untuk mengatur bidang usaha
  void setCompanyType(String type) {
    companyType.value = type;       // Set bidang usaha
  }

  // Method untuk mengatur alamat perusahaan
  void setCompanyAddress(String address) {
    companyAddress.value = address;  // Set alamat perusahaan
  }
}
