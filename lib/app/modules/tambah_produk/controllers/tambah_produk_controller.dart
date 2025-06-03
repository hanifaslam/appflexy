import 'dart:io';
import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';
import 'dart:convert';

class TambahProdukController extends GetxController {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  final box = GetStorage();
  
  // Observable states - sama seperti TambahTiketController
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Getter untuk token
  String? get token => box.read('token');

  void initializeProduk(Map<String, dynamic>? produk) {
    if (produk != null) {
      namaProdukController.text = produk['namaProduk'] ?? '';
      kodeProdukController.text = produk['kodeProduk'] ?? '';
      stokController.text = produk['stok']?.toString() ?? '0';
      hargaJualController.text = produk['hargaJual']?.toString() ?? '';
      keteranganController.text = produk['keterangan'] ?? '';
      kategoriController.text = produk['kategori'] ?? '';
      
      // Handle existing image if any
      if (produk['image'] != null && produk['image'].toString().isNotEmpty) {
        // Set existing image info if needed
        print('Existing image: ${produk['image']}');
      }
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
        update(); // Refresh UI after selecting image
        
        Get.snackbar(
          'Berhasil',
          'Gambar berhasil dipilih',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 1),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (error) {
      print('Error picking image: $error');
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: ${error.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<bool> addProduct() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = box.read('user_id');
      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final Uri apiUrl = Uri.parse(ApiConstants.getFullUrl(ApiConstants.products));
      final request = http.MultipartRequest('POST', apiUrl);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add text fields
      request.fields['namaProduk'] = namaProdukController.text.trim();
      request.fields['kodeProduk'] = kodeProdukController.text.trim();
      request.fields['stok'] = stokController.text.trim();
      request.fields['hargaJual'] = hargaJualController.text.trim();
      request.fields['keterangan'] = keteranganController.text.trim();
      request.fields['kategori'] = kategoriController.text.trim();
      request.fields['user_id'] = userId.toString();

      // Add image if selected
      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      // Send the request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      print('Add product response status: ${response.statusCode}');
      print('Add product response body: ${responseData.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success snackbar
        Get.snackbar(
          'Berhasil',
          'Produk berhasil ditambahkan!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        
        // Refresh daftar produk jika controller terdaftar
        if (Get.isRegistered<DaftarKasirController>()) {
          final daftarKasirController = Get.find<DaftarKasirController>();
          daftarKasirController.fetchProdukList();
        }
        
        clearFields();
        return true;
      } else {
        // Error response
        final errorData = json.decode(responseData.body);
        final errorMsg = errorData['message'] ?? 'Gagal menambahkan produk';
        errorMessage.value = errorMsg;
        
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        return false;
      }
    } catch (e) {
      print('Error adding product: $e');
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menambahkan produk',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProduct(int productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = box.read('user_id');
      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final Uri apiUrl = Uri.parse(ApiConstants.getFullUrl('${ApiConstants.products}/$productId'));
      final request = http.MultipartRequest('PUT', apiUrl);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add text fields
      request.fields['namaProduk'] = namaProdukController.text.trim();
      request.fields['kodeProduk'] = kodeProdukController.text.trim();
      request.fields['stok'] = stokController.text.trim();
      request.fields['hargaJual'] = hargaJualController.text.trim();
      request.fields['keterangan'] = keteranganController.text.trim();
      request.fields['kategori'] = kategoriController.text.trim();
      request.fields['user_id'] = userId.toString();

      // Add image if selected (new image)
      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage!.path,
        ));
      }

      // Send the request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      print('Update product response status: ${response.statusCode}');
      print('Update product response body: ${responseData.body}');

      if (response.statusCode == 200) {
        // Success snackbar
        Get.snackbar(
          'Berhasil',
          'Produk berhasil diupdate!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        
        // Refresh daftar produk jika controller terdaftar
        if (Get.isRegistered<DaftarKasirController>()) {
          final daftarKasirController = Get.find<DaftarKasirController>();
          daftarKasirController.fetchProdukList();
        }
        
        return true;
      } else {
        // Error response
        final errorData = json.decode(responseData.body);
        final errorMsg = errorData['message'] ?? 'Gagal mengupdate produk';
        errorMessage.value = errorMsg;
        
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
        return false;
      }
    } catch (e) {
      print('Error updating product: $e');
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
      
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengupdate produk',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Validation method
  bool validateFields() {
    if (namaProdukController.text.trim().isEmpty) {
      errorMessage.value = "Nama produk harus diisi!";
      return false;
    }
    
    if (kodeProdukController.text.trim().isEmpty) {
      errorMessage.value = "Kode produk harus diisi!";
      return false;
    }
    
    if (kategoriController.text.trim().isEmpty) {
      errorMessage.value = "Kategori harus dipilih!";
      return false;
    }
    
    if (stokController.text.trim().isEmpty || int.tryParse(stokController.text) == null || int.parse(stokController.text) <= 0) {
      errorMessage.value = "Stok harus lebih dari 0!";
      return false;
    }
    
    if (hargaJualController.text.trim().isEmpty || double.tryParse(hargaJualController.text) == null || double.parse(hargaJualController.text) <= 0) {
      errorMessage.value = "Harga sewa harus diisi dengan benar!";
      return false;
    }
    
    return true;
  }

  Map<String, dynamic> createNewProduk() {
    return {
      'namaProduk': namaProdukController.text.trim(),
      'kodeProduk': kodeProdukController.text.trim(),
      'stok': stokController.text.trim(),
      'hargaJual': hargaJualController.text.trim(),
      'keterangan': keteranganController.text.trim(),
      'kategori': kategoriController.text.trim(),
      'image': selectedImage?.path,
    };
  }

  void clearFields() {
    namaProdukController.clear();
    kodeProdukController.clear();
    stokController.clear();
    hargaJualController.clear();
    keteranganController.clear();
    kategoriController.clear();
    selectedImage = null;
    errorMessage.value = '';
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
