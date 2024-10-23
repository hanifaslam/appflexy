import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

 final box = GetStorage();
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
  void saveToStorage() {
    // Simpan ke GetStorage
    box.write('companyName', companyName.value);
    box.write('companyLogo', companyLogoPath.value);
  }
}
