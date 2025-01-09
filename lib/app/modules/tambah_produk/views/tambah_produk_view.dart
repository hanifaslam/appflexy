import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';

import '../controllers/tambah_produk_controller.dart';

class TambahProdukView extends StatefulWidget {
  final Map<String, dynamic>? produk;
  final int? index;

  TambahProdukView({this.produk, this.index});

  @override
  State<TambahProdukView> createState() => _TambahProdukViewState();
}

class _TambahProdukViewState extends State<TambahProdukView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TambahProdukController());

    controller.initializeProduk(widget.produk);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              controller.clearFields();
              Get.back(result: true);
            }),
        title: Text(
          widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
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
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: GetBuilder<TambahProdukController>(
                    builder: (controller) {
                      return Column(
                        children: [
                          TextField(
                            controller: controller.namaProdukController,
                            decoration: InputDecoration(
                              hintText: 'Nama Produk',
                              prefixIcon: Icon(
                                Bootstrap.box,
                                color: Color(0xff181681),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Color(0xff181681), width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.kodeProdukController,
                            decoration: InputDecoration(
                              hintText: 'Kode Produk',
                              prefixIcon: Icon(
                                Bootstrap.tags,
                                color: Color(0xff181681),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Color(0xff181681), width: 2.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.kategoriController,
                            decoration: InputDecoration(
                              hintText: 'Kategori',
                              prefixIcon: Icon(
                                Bootstrap.list,
                                color: Color(0xff181681),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Color(0xff181681), width: 2.0),
                              ),
                            ),
                          ),
                          const Gap(30),
                          TextField(
                            controller: controller.stokController,
                            decoration: InputDecoration(
                              hintText: 'Stok',
                              prefixIcon: Icon(
                                Bootstrap.box2,
                                color: Color(0xff181681),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Color(0xff181681), width: 2.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const Gap(30),
                          GestureDetector(
                            onTap: controller.pickImage,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    controller.selectedImage != null
                                        ? Image.file(
                                            controller.selectedImage!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Bootstrap.image,
                                            size: 50, color: Color(0xff181681)),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        controller.selectedImage != null
                                            ? 'Ganti Foto Produk'
                                            : 'Masukan Foto Produk',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'inter',
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.hargaJualController,
                            decoration: InputDecoration(
                              hintText: 'Harga Sewa',
                              prefixIcon: Icon(
                                IonIcons.cash,
                                color: Color(0xff181681),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Color(0xff181681), width: 2.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.keteranganController,
                            decoration: InputDecoration(
                              hintText: 'Keterangan Produk (opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Color(0xff181681), width: 2.0),
                              ),
                            ),
                            maxLines: 4,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
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
                    onPressed: () async {
                      if (controller.namaProdukController.text.isEmpty ||
                          controller.kodeProdukController.text.isEmpty ||
                          controller.kategoriController.text.isEmpty ||
                          controller.stokController.text.isEmpty ||
                          controller.hargaJualController.text.isEmpty) {
                        Get.snackbar('Error', 'Semua field harus diisi',
                            colorText: Colors.black.withOpacity(0.8),
                            barBlur: 15,
                            icon: const Icon(Icons.error, color: Colors.red),
                            duration: const Duration(seconds: 3),
                            snackPosition: SnackPosition.TOP);
                        return;
                      }

                      // Call the addProduct method to post the data
                      await controller.addProduct();
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
