import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
      'stok': stokController.text,
      'hargaJual': hargaJualController.text,
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
