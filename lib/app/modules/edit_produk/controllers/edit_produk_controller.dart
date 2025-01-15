import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EditProdukController extends GetxController {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  final box = GetStorage();
  String? existingImage;

  void initializeProduk(Map<String, dynamic>? produk) {
    if (produk != null) {
      namaProdukController.text = produk['namaProduk'] ?? '';
      kodeProdukController.text = produk['kodeProduk'] ?? '';
      stokController.text = produk['stok']?.toString() ?? '';
      hargaJualController.text = produk['hargaJual']?.toString() ?? '';
      keteranganController.text = produk['keterangan'] ?? '';
      kategoriController.text = produk['kategori'] ?? '';
      existingImage = produk['image'];
      update();
    }
  }

  bool hasImage() {
    return selectedImage != null ||
        (existingImage != null && existingImage!.isNotEmpty);
  }

  String? getImageUrl() {
    if (existingImage != null && existingImage!.isNotEmpty) {
      final baseUrl = 'https://flexy.my.id/storage/products/';
      return '$baseUrl$existingImage';
    }
    return null;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update();
      } else {
        Get.snackbar('No Image Selected', 'Please select an image');
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to pick image: $error');
    }
  }

  Future<void> updateProduct(int productId) async {
    final Uri apiUrl = Uri.parse('https://flexy.my.id/api/products/$productId');
    final userId = box.read('user_id');

    // Validasi input
    if (namaProdukController.text.isEmpty) {
      Get.snackbar('Error', 'Nama Produk tidak boleh kosong');
      return;
    }

    try {
      final request = http.MultipartRequest('POST', apiUrl);

      // Simulasi PUT
      request.fields['_method'] = 'PUT';

      // Tambah field teks
      request.fields['namaProduk'] = namaProdukController.text;
      request.fields['kodeProduk'] = kodeProdukController.text;
      request.fields['stok'] = stokController.text;
      request.fields['hargaJual'] = hargaJualController.text;
      request.fields['keterangan'] = keteranganController.text;
      request.fields['kategori'] = kategoriController.text;
      request.fields['user_id'] = userId.toString();

      // Tambahkan gambar jika ada
      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      // Kirim request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product updated successfully');
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Response body: ${responseData.body}');
        Get.snackbar('Error', 'Failed to update product: ${responseData.body}');
      }
    } catch (error) {
      Get.snackbar('Error', 'An error occurred: $error');
    }
  }

  @override
  void onClose() {
    namaProdukController.dispose();
    kodeProdukController.dispose();
    stokController.dispose();
    hargaJualController.dispose();
    keteranganController.dispose();
    kategoriController.dispose();
    super.onClose();
  }
}
