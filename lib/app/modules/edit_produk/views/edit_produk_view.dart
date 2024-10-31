import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/modules/edit_produk/controllers/edit_produk_controller.dart';

class EditProdukView extends StatefulWidget {
  final Map<String, dynamic>? produk;
  final int? index;

  EditProdukView({this.produk, this.index});

  @override
  State<EditProdukView> createState() => _EditProdukViewState();
}

class _EditProdukViewState extends State<EditProdukView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProdukController());

    controller.initializeProduk(widget.produk);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
                  child: GetBuilder<EditProdukController>(
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
                                  color: Color(0xff181681),
                                  width: 2.0,
                                ),
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
                                  color: Color(0xff181681),
                                  width: 2.0,
                                ),
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
                                  color: Color(0xff181681),
                                  width: 2.0,
                                ),
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
                                  color: Color(0xff181681),
                                  width: 2.0,
                                ),
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
                                        : (widget.produk != null &&
                                                widget.produk!['image'] != null)
                                            ? Image.file(
                                                File(widget.produk!['image']),
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(Bootstrap.image,
                                                size: 50,
                                                color: Color(0xff181681)),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        controller.selectedImage != null
                                            ? 'Ganti Foto Produk'
                                            : (widget.produk != null &&
                                                    widget.produk!['image'] !=
                                                        null)
                                                ? 'Foto Produk Saat Ini'
                                                : 'Masukan Foto Produk',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'inter',
                                          fontStyle: FontStyle.normal,
                                        ),
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
                                  color: Color(0xff181681),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.keteranganController,
                            decoration: InputDecoration(
                              hintText: 'Keterangan',
                              prefixIcon: Icon(
                                IonIcons.text,
                                color: Color(0xff181681),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                  color: Color(0xff181681),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          // Add more fields if needed...
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Add a button or footer if needed...
            ],
          ),
        ),
      ),
    );
  }
}
