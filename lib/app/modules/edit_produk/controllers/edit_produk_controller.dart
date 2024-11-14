import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../daftar_produk/controllers/daftar_produk_controller.dart';

class EditProdukController extends GetxController {
  // Form Controllers
  final namaProdukController = TextEditingController();
  final kodeProdukController = TextEditingController();
  final stokController = TextEditingController();
  final hargaJualController = TextEditingController();
  final keteranganController = TextEditingController();
  final kategoriController = TextEditingController();

  // Image Selection
  final selectedImageRx = Rx<File?>(null);
  File? get selectedImage => selectedImageRx.value;
  set selectedImage(File? value) => selectedImageRx.value = value;
  final ImagePicker _picker = ImagePicker();

  // Form Key untuk validasi
  final formKey = GlobalKey<FormState>();

  // Base URL API
  final String baseUrl =
      'http://10.0.2.2:8000/api'; // Gunakan ini untuk Android Emulator
  // final String baseUrl = 'http://localhost:8000/api'; // Gunakan ini untuk iOS Simulator

  // Dependencies
  late final DaftarProdukController _daftarProdukController;

  @override
  void onInit() {
    super.onInit();
    try {
      _daftarProdukController = Get.find<DaftarProdukController>();
    } catch (e) {
      _daftarProdukController = Get.put(DaftarProdukController());
    }
  }

  // Image Picker Method dengan error handling yang lebih baik
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image
        maxWidth: 1000, // Limit max width
        maxHeight: 1000, // Limit max height
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        // Verify file exists and is an image
        if (await imageFile.exists()) {
          selectedImageRx.value = imageFile;
        } else {
          throw Exception('File tidak ditemukan');
        }
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memilih gambar: ${e.toString()}');
    }
  }

  // Method untuk set image dari path yang sudah ada
  void setImageFromPath(String path) {
    try {
      if (path.isNotEmpty) {
        final File file = File(path);
        if (file.existsSync()) {
          selectedImageRx.value = file;
        } else {
          throw Exception('File gambar tidak ditemukan');
        }
      }
    } catch (e) {
      _showErrorSnackbar('Gagal mengatur gambar: ${e.toString()}');
    }
  }

  // Update Product Method dengan error handling yang lebih baik
  Future<void> updateProduct(int productId) async {
    if (!_validateInputs()) return;

    try {
      _showLoadingDialog();

      final url = Uri.parse('$baseUrl/products/$productId');
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        });

      // Add PUT method simulation
      request.fields['_method'] = 'PUT';

      // Add product data
      final productData = _prepareProductData();
      request.fields.addAll(productData);

      // Add image if selected
      await _addImageToRequest(request);

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timeout setelah 30 detik');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      Get.back(); // Close loading dialog

      _handleUpdateResponse(response, productId, productData);
    } on SocketException catch (e) {
      Get.back();
      _showErrorSnackbar(
          'Koneksi gagal: Pastikan server berjalan dan dapat diakses\n${e.toString()}');
    } on TimeoutException catch (e) {
      Get.back();
      _showErrorSnackbar('Request timeout: ${e.toString()}');
    } catch (e) {
      Get.back();
      _showErrorSnackbar('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Add new product method
  Future<void> addProduct() async {
    if (!_validateInputs()) return;

    try {
      _showLoadingDialog();

      final url = Uri.parse('$baseUrl/products');
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        });

      // Add product data
      final productData = _prepareProductData();
      request.fields.addAll(productData);

      // Add image if selected
      await _addImageToRequest(request);

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timeout setelah 30 detik');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      Get.back(); // Close loading dialog

      _handleAddResponse(response, productData);
    } on SocketException catch (e) {
      Get.back();
      _showErrorSnackbar(
          'Koneksi gagal: Pastikan server berjalan dan dapat diakses\n${e.toString()}');
    } on TimeoutException catch (e) {
      Get.back();
      _showErrorSnackbar('Request timeout: ${e.toString()}');
    } catch (e) {
      Get.back();
      _showErrorSnackbar('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Prepare product data
  Map<String, String> _prepareProductData() {
    return {
      'namaProduk': namaProdukController.text.trim(),
      'kodeProduk': kodeProdukController.text.trim(),
      'stok': stokController.text.trim(),
      'hargaJual': hargaJualController.text.trim(),
      'keterangan': keteranganController.text.trim(),
      'kategori': kategoriController.text.trim(),
    };
  }

  // Add image to request
  Future<void> _addImageToRequest(http.MultipartRequest request) async {
    if (selectedImageRx.value != null &&
        await selectedImageRx.value!.exists()) {
      final filename =
          'product_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          selectedImageRx.value!.path,
          filename: filename,
        ),
      );
    }
  }

  // Handle update response
  void _handleUpdateResponse(
      http.Response response, int productId, Map<String, String> productData) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Update produk di controller daftar produk
        _daftarProdukController.updateProduct(productId, productData);

        // Tampilkan pesan sukses dengan snackbar hijau
        Get.snackbar(
          'Sukses',
          'Produk berhasil diupdate',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(8),
        );

        // Kembali ke halaman sebelumnya
        Get.back(result: true);
      } else {
        // Tangani error dari API
        final errorMessage = _parseErrorResponse(response.body);
        _showErrorSnackbar('Error ${response.statusCode}: $errorMessage');
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memproses response: ${e.toString()}');
    }
  }

  // Handle add response
  void _handleAddResponse(
      http.Response response, Map<String, String> productData) {
    try {
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final newProductId = responseData['id'];

        if (newProductId != null) {
          _daftarProdukController.addProduct({
            'id': newProductId,
            ...productData,
          });
          Get.back(result: true);
          _showSuccessSnackbar('Produk berhasil ditambahkan');
          clearFields();
        } else {
          _showErrorSnackbar('ID produk tidak ditemukan dalam response');
        }
      } else {
        final errorMessage = _parseErrorResponse(response.body);
        _showErrorSnackbar('Error ${response.statusCode}: $errorMessage');
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memproses response: ${e.toString()}');
    }
  }

  // Parse error response
  String _parseErrorResponse(String responseBody) {
    try {
      final errorJson = json.decode(responseBody);
      if (errorJson is Map<String, dynamic>) {
        if (errorJson.containsKey('errors')) {
          final errors = errorJson['errors'];
          if (errors is Map) {
            return errors.values
                .expand((e) => e is List ? e : [e.toString()])
                .join('\n');
          }
          return errors.toString();
        }
        return errorJson['message'] ??
            errorJson['error'] ??
            'Unknown error occurred';
      }
      return responseBody;
    } catch (e) {
      return 'Failed to parse error response: $responseBody';
    }
  }

  // Input validation
  bool _validateInputs() {
    if (!formKey.currentState!.validate()) return false;

    if (namaProdukController.text.trim().isEmpty) {
      _showErrorSnackbar('Nama Produk harus diisi');
      return false;
    }

    if (kodeProdukController.text.trim().isEmpty) {
      _showErrorSnackbar('Kode Produk harus diisi');
      return false;
    }

    try {
      final stok = int.parse(stokController.text);
      if (stok < 0) {
        _showErrorSnackbar('Stok tidak boleh negatif');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Stok harus berupa angka');
      return false;
    }

    try {
      final hargaJual = double.parse(hargaJualController.text);
      if (hargaJual < 0) {
        _showErrorSnackbar('Harga sewa tidak boleh negatif');
        return false;
      }
    } catch (e) {
      _showErrorSnackbar('Harga sewa harus berupa angka');
      return false;
    }

    return true;
  }

  // Utility methods
  void clearFields() {
    namaProdukController.clear();
    kodeProdukController.clear();
    stokController.clear();
    hargaJualController.clear();
    keteranganController.clear();
    kategoriController.clear();
    selectedImageRx.value = null;
  }

  void _showLoadingDialog() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
  }

  // Perbaikan method _showErrorSnackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  // Perbaikan method _showSuccessSnackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Sukses',
      message,
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
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
