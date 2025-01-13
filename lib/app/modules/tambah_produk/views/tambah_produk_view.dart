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
  final List<String> categories = [
    'Makanan',
    'Minuman',
    'Alat Transportasi',
    'Alat Renang'
  ];
  
  final List<int> stockOptions = [5, 10, 20, 50, 100];

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
          }
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<TambahProdukController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        // Nama Produk
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
                                width: 2.0
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Kode Produk
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
                                width: 2.0
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Kategori Dropdown
                        // ... (previous imports and class declarations remain the same)

// Only showing the modified Kategori dropdown section, rest remains unchanged
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(11),
  ),
  child: Row(
    children: [
      // Icon
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Icon(
          Bootstrap.list,
          color: Color(0xff181681),
        ),
      ),
      const SizedBox(width: 10),
      // Dynamic text that shows either "Kategori" or selected value
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            controller.kategoriController.text.isEmpty 
                ? 'Kategori' 
                : controller.kategoriController.text,
            style: TextStyle(
              color: controller.kategoriController.text.isEmpty 
                  ? Colors.grey[600] 
                  : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
      // Dropdown button
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: PopupMenuButton<String>(
          icon: Icon(Icons.arrow_drop_down, color: Color(0xff181681)),
          onSelected: (String value) {
            controller.kategoriController.text = value;
            controller.update();
          },
          itemBuilder: (BuildContext context) {
            return categories.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList();
          },
        ),
      ),
    ],
  ),
),
                        const Gap(30),

                        // Stok Input
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Stok Label
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Bootstrap.box2,
                                      color: Color(0xff181681),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Stok',
                                      style: TextStyle(
                                        color: Color(0xff181681),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Counter
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                                      if (currentStock > 0) {
                                        controller.stokController.text = (currentStock - 1).toString();
                                        controller.update();
                                      }
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    controller.stokController.text.isEmpty 
                                        ? '0' 
                                        : controller.stokController.text,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(width: 20),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                                      controller.stokController.text = (currentStock + 1).toString();
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                              // Quick Stock Options
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: stockOptions.map((int stock) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff181681),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      onPressed: () {
                                        controller.stokController.text = stock.toString();
                                        controller.update();
                                      },
                                      child: Text('$stock', style: TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(30),

                        // Foto Produk
                        GestureDetector(
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text(
                                      controller.selectedImage != null
                                          ? 'Ganti Foto Produk'
                                          : 'Masukan Foto Produk',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'inter',
                                        fontStyle: FontStyle.normal
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Harga Sewa
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
                                width: 2.0
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        // Keterangan
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
                                color: Color(0xff181681),
                                width: 2.0
                              ),
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
            // Bottom Button
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
                      Get.snackbar(
                        'Error',
                        'Semua kolom harus diisi',
                        colorText: Colors.black.withOpacity(0.8),
                        barBlur: 15,
                        icon: const Icon(Icons.error, color: Colors.red),
                        duration: const Duration(seconds: 3),
                        snackPosition: SnackPosition.TOP
                      );
                      return;
                    }
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
    );
  }
}