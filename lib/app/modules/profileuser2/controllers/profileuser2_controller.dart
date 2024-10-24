import 'package:get/get.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

class Profileuser2Controller extends GetxController {
  // Observable untuk data penjualan dan pengeluaran
  var penjualan = 4000000.obs;
  var pengeluaran = 1500000.obs;

  // Observable untuk nama perusahaan dan path logo
  var companyName = ''.obs;
  var companyLogo = ''.obs;  // Path untuk logo

  @override
  void onInit() {
    super.onInit();
    // Membaca data yang tersimpan, jika tidak ada maka menggunakan default value
    var storedName = box.read('companyName') ?? 'Aqua Bliss Pool';
    var storedLogo = box.read('companyLogo') ?? '';

    // Memperbarui data controller dengan data dari penyimpanan
    setCompanyDetails(storedName, storedLogo);
  }

  // Fungsi untuk mengupdate nama dan logo
  void setCompanyDetails(String name, String logoPath) {
    companyName.value = name;
    companyLogo.value = logoPath;

    // Simpan ke GetStorage untuk persistensinya
    box.write('companyName', name);
    box.write('companyLogo', logoPath);
  }

  // Fungsi untuk memperbarui nama perusahaan
  void setCompanyName(String name) {
    companyName.value = name;

    // Simpan perubahan ke penyimpanan
    box.write('companyName', name);
    // Notifikasi perubahan
    Get.snackbar('Perubahan Disimpan', 'Nama perusahaan berhasil diperbarui');
  }

  // Fungsi untuk memperbarui logo perusahaan
  void setCompanyLogo(String logoPath) {
    companyLogo.value = logoPath;

    // Simpan path logo ke penyimpanan
    box.write('companyLogo', logoPath);
    // Notifikasi perubahan
    Get.snackbar('Perubahan Disimpan', 'Logo perusahaan berhasil diperbarui');
  }

  // Fungsi untuk mengambil logo dari penyimpanan
  String getLogoFilePath() {
    return companyLogo.value.isEmpty
        ? 'assets/images/default_logo.png'  // Logo default jika tidak ada
        : companyLogo.value;  // Path logo dari penyimpanan
  }
}
