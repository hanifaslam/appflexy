import 'package:get/get.dart';

class ProfileController extends GetxController {
  var companyName = ''.obs;
  var companyType = ''.obs;
  var companyAddress = ''.obs;

  void setCompanyName(String value) {
    companyName.value = value;
  }

  void setCompanyType(String value) {
    companyType.value = value;
  }

  void setCompanyAddress(String value) {
    companyType.value = value;
  }

  void clearInput() {
    companyName.value = '';
    companyType.value = '';
    companyAddress.value = '';
  }
}
