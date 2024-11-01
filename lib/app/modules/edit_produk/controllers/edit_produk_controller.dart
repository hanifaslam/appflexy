import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProdukController extends GetxController {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  // Initialize fields for editing
  void initializeProduk(Map<String, dynamic>? produk) {
    if (produk != null) {
      namaProdukController.text = produk['namaProduk'] ?? '';
      kodeProdukController.text = produk['kodeProduk'] ?? '';
      stokController.text = (produk['stok'] ?? 0).toString();
      hargaJualController.text = (produk['hargaJual'] ?? 0.0).toString();
      keteranganController.text = produk['keterangan'] ?? '';
      kategoriController.text = produk['kategori'] ?? '';

      // Set the selected image if it exists
      if (produk['image'] != null) {
        selectedImage = File(produk['image']);
      }
    }
  }

  // Clear fields when adding a new product
  void clearFields() {
    namaProdukController.clear();
    kodeProdukController.clear();
    stokController.clear();
    hargaJualController.clear();
    keteranganController.clear();
    kategoriController.clear();
    selectedImage = null; // Clear selected image as well
    update(); // Update the UI
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    }
  }

  Map<String, dynamic> createNewProduk() {
    return {
      'namaProduk': namaProdukController.text,
      'kodeProduk': kodeProdukController.text,
      'stok': int.tryParse(stokController.text) ?? 0,
      'hargaJual': double.tryParse(hargaJualController.text) ?? 0.0,
      'keterangan': keteranganController.text,
      'kategori': kategoriController.text,
      'image': selectedImage?.path,
    };
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
