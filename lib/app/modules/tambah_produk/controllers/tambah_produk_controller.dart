import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../daftar_produk/controllers/daftar_produk_controller.dart';

class TambahProdukController extends GetxController {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  File? selectedImage;
  String? existingImagePath;
  final ImagePicker picker = ImagePicker();
  int? productId;

  void initializeProduk(Map<String, dynamic>? produk) {
    if (produk != null) {
      productId = produk['id'];
      namaProdukController.text = produk['namaProduk'] ?? '';
      kodeProdukController.text = produk['kodeProduk'] ?? '';
      stokController.text = produk['stok']?.toString() ?? '';
      hargaJualController.text = produk['hargaJual']?.toString() ?? '';
      keteranganController.text = produk['keterangan'] ?? '';
      kategoriController.text = produk['kategori'] ?? '';

      if (produk['image'] != null && produk['image'].isNotEmpty) {
        existingImagePath = produk['image'];
      }
      // Debugging: Print values
      print('Initialize Produk: $produk');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      existingImagePath = null;
      update();
    }
  }

  Map<String, dynamic> createProdukData() {
    return {
      'id': productId,
      'namaProduk': namaProdukController.text,
      'kodeProduk': kodeProdukController.text,
      'stok': int.parse(stokController.text),
      'hargaJual': hargaJualController.text, // Pastikan ini adalah string
      'keterangan': keteranganController.text,
      'kategori': kategoriController.text,
      'image': selectedImage?.path ??
          existingImagePath, // Jika image tidak tersedia, kirim null
    };
  }

  Future<bool> saveProduk() async {
    final isUpdate = productId != null;
    final url = 'http://127.0.0.1:8000/api/products/${productId ?? ''}';

    try {
      // Choose request type based on action (PUT for update, POST for create)
      var request = isUpdate
          ? http.MultipartRequest('PUT', Uri.parse(url))
          : http.MultipartRequest(
              'POST', Uri.parse('http://127.0.0.1:8000/api/products'));

      // Product data fields
      request.fields['namaProduk'] = namaProdukController.text;
      request.fields['kodeProduk'] = kodeProdukController.text;
      request.fields['stok'] = stokController.text;
      request.fields['hargaJual'] = hargaJualController.text;
      request.fields['keterangan'] = keteranganController.text;
      request.fields['kategori'] = kategoriController.text;

      // Attach image if selected
      if (selectedImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', selectedImage!.path));
      } else {
        request.fields['image'] = 'null'; // Mengirimkan 'null' sebagai string
      }

      // Send the request and handle response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if ((isUpdate && response.statusCode == 200) ||
          (!isUpdate && response.statusCode == 201)) {
        final daftarProdukController = Get.find<DaftarProdukController>();

        if (isUpdate) {
          // Update the product in DaftarProdukController
          final updatedProduct = createProdukData();
          daftarProdukController.updateProduct(productId!, updatedProduct);
          _showSnackbar('Success', 'Produk berhasil diperbarui');
        } else {
          final createdProduct = json.decode(response.body);
          daftarProdukController.addProduct(createdProduct);
          _showSnackbar('Success', 'Produk berhasil ditambahkan');
        }
        Get.back();
        return true;
      } else {
        _showSnackbar('Error',
            'Gagal ${isUpdate ? "memperbarui" : "menambahkan"} produk: ${response.statusCode}\n${response.body}');
        return false;
      }
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan: $e');
      return false;
    }
  }

  void _showSnackbar(String title, String message) {
    if ((Get.isDialogOpen ?? false) == false) {
      Get.snackbar(title, message, duration: Duration(seconds: 5));
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
