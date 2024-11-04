import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/modules/edit_produk/controllers/edit_produk_controller.dart';

class EditProdukView extends GetView<EditProdukController> {
  final Map<String, dynamic>? produk;
  final int? index;

  const EditProdukView({Key? key, this.produk, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller jika belum ada
    if (produk != null) {
      _initializeControllerWithProductData();
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          produk == null ? 'Tambah Produk' : 'Edit Produk',
          style: const TextStyle(
            color: Color(0xff181681),
            fontFamily: 'Inter',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => Column(
                        children: [
                          _buildTextField(
                            controller: controller.namaProdukController,
                            hintText: 'Nama Produk',
                            icon: Bootstrap.box,
                            validator: (value) =>
                                _validateRequired(value, 'Nama Produk'),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: controller.kodeProdukController,
                            hintText: 'Kode Produk',
                            icon: Bootstrap.tags,
                            validator: (value) =>
                                _validateRequired(value, 'Kode Produk'),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: controller.kategoriController,
                            hintText: 'Kategori',
                            icon: Bootstrap.list,
                            validator: (value) =>
                                _validateRequired(value, 'Kategori'),
                          ),
                          const Gap(30),
                          _buildTextField(
                            controller: controller.stokController,
                            hintText: 'Stok',
                            icon: Bootstrap.box2,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                _validateNumber(value, 'Stok'),
                          ),
                          const Gap(30),
                          _buildImagePicker(),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: controller.hargaJualController,
                            hintText: 'Harga Sewa',
                            icon: IonIcons.cash,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                _validateNumber(value, 'Harga Sewa'),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: controller.keteranganController,
                            hintText: 'Keterangan',
                            icon: IonIcons.text,
                            validator: (value) =>
                                _validateRequired(value, 'Keterangan'),
                          ),
                        ],
                      )),
                ),
              ),
              // Update button
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _initializeControllerWithProductData() {
    // Mengisi controller dengan data produk yang ada
    controller.namaProdukController.text = produk?['namaProduk'] ?? '';
    controller.kodeProdukController.text = produk?['kodeProduk'] ?? '';
    controller.kategoriController.text = produk?['kategori'] ?? '';
    controller.stokController.text = produk?['stok']?.toString() ?? '';
    controller.hargaJualController.text =
        produk?['hargaJual']?.toString() ?? '';
    controller.keteranganController.text = produk?['keterangan'] ?? '';
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: const Color(0xff181681),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: Color(0xff181681),
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildImagePreview(),
              const SizedBox(width: 8),
              Text(
                _getImagePickerText(),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'inter',
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (controller.selectedImage != null) {
      return Image.file(
        controller.selectedImage!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if (produk != null && produk!['image'] != null) {
      return Image.file(
        File(produk!['image']),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      return const Icon(
        Bootstrap.image,
        size: 50,
        color: Color(0xff181681),
      );
    }
  }

  String _getImagePickerText() {
    if (controller.selectedImage != null) {
      return 'Ganti Foto Produk';
    } else if (produk != null && produk!['image'] != null) {
      return 'Foto Produk Saat Ini';
    } else {
      return 'Masukan Foto Produk';
    }
  }

  Widget _buildUpdateButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _onUpdatePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff181681),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            produk == null ? 'Tambah Produk' : 'Update Produk',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _onUpdatePressed() {
    if (controller.formKey.currentState!.validate()) {
      if (produk != null) {
        // Update produk yang sudah ada
        controller.updateProduct(produk!['id']);
      } else {
        // Tambah produk baru
        controller.addProduct();
      }
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName harus diisi';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName harus diisi';
    }
    if (int.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }
    return null;
  }
}
