import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profileuser2Controller extends GetxController {
  var penjualan = 4000000.obs;
  var pengeluaran = 1500000.obs;

  // Rx untuk menyimpan path file gambar yang dipilih
  var selectedImagePath = ''.obs;

  // Fungsi untuk mengambil gambar dari gallery menggunakan image_picker
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImagePath.value = image.path; // Update path gambar yang dipilih
    } else {
      Get.snackbar('Error', 'No image selected'); // Notifikasi kalau gambar tidak dipilih
    }
  }
}
