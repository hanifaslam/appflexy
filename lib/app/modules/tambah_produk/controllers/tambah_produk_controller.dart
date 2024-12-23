import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';

class TambahProdukController extends GetxController {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  void initializeProduk(Map<String, dynamic>? produk) {
    if (produk != null) {
      namaProdukController.text = produk['namaProduk'];
      kodeProdukController.text = produk['kodeProduk'];
      stokController.text = produk['stok'];
      hargaJualController.text = produk['hargaJual'];
      keteranganController.text = produk['keterangan'];
      kategoriController.text = produk['kategori'];
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update(); // Refresh UI after selecting image
      } else {
        Get.snackbar('No Image Selected', 'Please select an image');
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to pick image: $error');
    }
  }

  Map<String, dynamic> createNewProduk() {
    return {
      'namaProduk': namaProdukController.text,
      'kodeProduk': kodeProdukController.text,
      'stok': stokController.text,
      'hargaJual': hargaJualController.text,
      'keterangan': keteranganController.text,
      'kategori': kategoriController.text,
      'image': selectedImage?.path,
    };
  }

  Future<void> addProduct() async {
    final Uri apiUrl = Uri.parse(
        'http://10.0.2.2:8000/api/products'); // Ganti dengan endpoint API Anda

    try {
      final request = http.MultipartRequest('POST', apiUrl);

      // Add text fields
      request.fields['namaProduk'] = namaProdukController.text;
      request.fields['kodeProduk'] = kodeProdukController.text;
      request.fields['stok'] = stokController.text;
      request.fields['hargaJual'] = hargaJualController.text;
      request.fields['keterangan'] = keteranganController.text;
      request.fields['kategori'] = kategoriController.text;

      // Add image if selected
      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // The key in your API for the image file
          selectedImage!.path,
        ));
      }

      // Send the request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Product added successfully');
        clearFields();
      } else {
        print('Failed with status: ${response.statusCode}');
        print('Response body: ${responseData.body}');
        Get.snackbar('Error', 'Failed to add product: ${responseData.body}');
      }
    } catch (error) {
      // Handle any other error
      Get.snackbar('Error', 'An error occurred: $error');
    }
  }

  void clearFields() {
    namaProdukController.clear();
    kodeProdukController.clear();
    stokController.clear();
    hargaJualController.clear();
    keteranganController.clear();
    kategoriController.clear();
    selectedImage = null;
    update();
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
