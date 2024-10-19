import 'package:get/get.dart';
import 'dart:io';

class Profileuser2Controller extends GetxController {
  var penjualan = 4000000.obs;
  var pengeluaran = 1500000.obs;

  // Company name and logo path
  var companyName = ''.obs;
  var companyLogo = ''.obs;  // Path untuk logo

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments; // Mengambil argumen yang diteruskan
    if (args != null) {
      // Set nama dan logo perusahaan berdasarkan argumen
      setCompanyDetails(args['companyName'] ?? '', args['companyLogo'] ?? '');
    }
  }

  // Function to set company name and logo from profile page
  void setCompanyDetails(String name, String logoPath) {
    companyName.value = name.isNotEmpty ? name : 'Aqua Bliss Pool';
    companyLogo.value = logoPath.isNotEmpty ? logoPath : '';  // Default to empty if no logo
  }
}
