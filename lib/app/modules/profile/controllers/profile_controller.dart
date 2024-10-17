import 'package:get/get.dart';

class ProfileController extends GetxController {
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;
  var companyLogoPath = ''.obs; // Untuk menyimpan path logo toko

  void setCompanyName(String name) {
    companyName.value = name;
  }

  void setcompanyType(String type) {
    companyType.value = type;
  }

  void setcompanyAddress(String address) {
    companyAddress.value = address;
  }

  void setCompanyLogo(String path) {
    companyLogoPath.value = path; // Path gambar yang dipilih
  }
}
