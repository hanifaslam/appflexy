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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff181681),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Color(0xff365194).withOpacity(0.6),
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
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Bootstrap.box,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(11),
                                    borderSide: BorderSide(
                                        color: Color(0xff181681), width: 2.0))),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.kodeProdukController,
                            decoration: InputDecoration(
                              hintText: 'Kode Produk',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Bootstrap.tags,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Color(0xff181681), width: 2.0)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.kategoriController,
                            decoration: InputDecoration(
                              hintText: 'Kategori',
                              prefixIcon: Icon(Bootstrap.list),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Color(0xff181681), width: 2.0)),
                            ),
                          ),
                          const Gap(30),
                          TextField(
                            controller: controller.stokController,
                            decoration: InputDecoration(
                              hintText: 'Stok',
                              prefixIcon: Icon(Bootstrap.box2),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Color(0xff181681), width: 2.0)),
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
                                    Border.all(color: Colors.grey, width: 1),
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
                                            size: 50, color: Colors.grey),
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
                              prefixIcon: Icon(IonIcons.cash),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Color(0xff181681), width: 2.0)),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.keteranganController,
                            decoration: InputDecoration(
                              hintText: 'Keterangan Produk',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                      color: Color(0xff181681), width: 2.0)),
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
                  color: Colors.white.withOpacity(0.8),
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
                    onPressed: () {
                      final newProduk = controller.createNewProduk();
                      Get.back(result: newProduk);
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
