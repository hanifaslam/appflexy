import 'package:get/get.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';

 final box = GetStorage();

class Profileuser2Controller extends GetxController {
  var penjualan = 4000000.obs;
  var pengeluaran = 1500000.obs;

  // Company name and logo path
  var companyName = ''.obs;
  var companyLogo = ''.obs;  // Path untuk logo

  @override
void onInit() {
  super.onInit();
  var storedName = box.read('companyName') ?? 'Aqua Bliss Pool';
  var storedLogo = box.read('companyLogo') ?? '';

  setCompanyDetails(storedName, storedLogo);
}

void setCompanyDetails(String name, String logoPath) {
  companyName.value = name;
  companyLogo.value = logoPath;
}
}
