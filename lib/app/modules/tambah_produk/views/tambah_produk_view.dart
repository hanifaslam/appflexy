import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/tambah_produk_controller.dart';

class TambahProdukView extends StatelessWidget {
  final Map<String, dynamic>? produk;
  final int? index;

  TambahProdukView({Key? key, this.produk, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProdukController controller = Get.find<ProdukController>();

    // Inisialisasi jika ada data produk yang diberikan
    if (produk != null) {
      controller.namaProdukController.text = produk!['namaProduk'] ?? '';
      controller.kodeProdukController.text = produk!['kodeProduk'] ?? '';
      controller.stokController.text = produk!['stok']?.toString() ?? '';
      controller.hargaJualController.text =
          produk!['hargaJual']?.toString() ?? '';
      controller.keteranganController.text = produk!['keterangan'] ?? '';
      controller.kategoriValue.value = produk!['kategori'];
      // Initialize image if available
      // if (produk!['image'] != null) {
      //   controller.selectedImage.value = File(produk!['image']);
      // }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.namaProdukController,
                  decoration: InputDecoration(
                    hintText: 'Nama Produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.kodeProdukController,
                  decoration: InputDecoration(
                    hintText: 'Kode Produk',
                    prefixIcon: const Icon(Icons.tag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Kategori',
                        prefixIcon: const Icon(Icons.list),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      value: controller.kategoriValue.value,
                      items: controller.kategori.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        controller.kategoriValue.value = newValue!;
                      },
                    )),
                const Gap(30),
                TextField(
                  controller: controller.stokController,
                  decoration: InputDecoration(
                    hintText: 'Stok',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const Gap(30),
                GestureDetector(
                  // onTap: controller.pickImage, // Fungsi untuk memilih gambar
                  child: Row(
                    children: [
                      Obx(() => controller.selectedImage.value != null
                          ? Image.file(
                              File(controller.selectedImage.value!.path),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 100)),
                      const SizedBox(width: 8),
                      const Text(
                        'Masukan Foto Produk',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.hargaJualController,
                  decoration: InputDecoration(
                    hintText: 'Harga Sewa',
                    prefixIcon: const Icon(Icons.money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.keteranganController,
                  decoration: InputDecoration(
                    hintText: 'Keterangan Produk',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  maxLines: 4,
                ),
                const Gap(70),
                ElevatedButton(
                  onPressed: () {
                    final produkBaru = {
                      'namaProduk': controller.namaProdukController.text,
                      'kodeProduk': controller.kodeProdukController.text,
                      'stok': int.tryParse(controller.stokController.text) ?? 0,
                      'hargaJual': double.tryParse(
                              controller.hargaJualController.text) ??
                          0.0,
                      'kategori': controller.kategoriValue.value,
                      'keterangan': controller.keteranganController.text,
                      'image': controller.selectedImage.value?.path
                    };
                    Get.back(result: produkBaru); // Kembalikan data produk baru
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Tambahkan Produk',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
