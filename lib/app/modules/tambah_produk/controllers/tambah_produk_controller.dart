import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProdukController extends GetxController {
  final namaProdukController = TextEditingController();
  final kodeProdukController = TextEditingController();
  final stokController = TextEditingController();
  final hargaJualController = TextEditingController();
  final keteranganController = TextEditingController();

  var kategoriValue =
      Rxn<String>(); // Make kategoriValue observable and nullable
  List<String> kategori = ['Elektronik', 'Fashion', 'Makanan', 'Minuman'];

  Rx<File?> selectedImage = Rx<File?>(null); // Make selectedImage observable
  final ImagePicker picker = ImagePicker();
  final String apiUrl =
      'http://127.0.0.1:8000/api/products'; // Replace with your API URL

  // Future<void> pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     selectedImage.value = File(pickedFile.path);
  //   }
  // }

  Future<void> addProduk() async {
    if (namaProdukController.text.isEmpty ||
        kodeProdukController.text.isEmpty ||
        stokController.text.isEmpty ||
        hargaJualController.text.isEmpty ||
        kategoriValue.value == null) {
      Get.snackbar('Error', 'Semua kolom harus diisi');
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['namaProduk'] = namaProdukController.text;
      request.fields['kodeProduk'] = kodeProdukController.text;
      request.fields['stok'] = stokController.text;
      request.fields['hargaJual'] =
          double.parse(hargaJualController.text).toStringAsFixed(2);
      request.fields['keterangan'] = keteranganController.text;
      request.fields['kategori'] = kategoriValue.value!;

      // if (selectedImage.value != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath('image', selectedImage.value!.path),
      //   );
      // }

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Produk berhasil ditambahkan');
        clearFields();
      } else {
        Get.snackbar('Error',
            'Gagal menambahkan produk. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  void clearFields() {
    namaProdukController.clear();
    kodeProdukController.clear();
    stokController.clear();
    hargaJualController.clear();
    keteranganController.clear();
    kategoriValue.value = null;
    selectedImage.value = null;
  }
}
