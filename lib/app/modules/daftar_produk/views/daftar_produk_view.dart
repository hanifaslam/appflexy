import 'dart:io'; // Untuk menggunakan File
import 'package:apptiket/app/modules/edit_produk/views/edit_produk_view.dart';
import 'package:apptiket/app/modules/tambah_produk/views/tambah_produk_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../edit_produk/controllers/edit_produk_controller.dart';
import '../controllers/daftar_produk_controller.dart';

class DaftarProdukView extends StatelessWidget {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final DaftarProdukController controller =
      Get.put(DaftarProdukController()); // Instantiate the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: TextField(
            onChanged: (query) => controller.updateSearchQuery(query),
            decoration: InputDecoration(
              hintText: 'Cari Nama Produk',
              hintStyle: TextStyle(color: Color(0xff181681)),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[350],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showSortDialog(context); // Tampilkan dialog pengurutan
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.filteredProdukList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Tidak ada daftar produk yang dapat ditampilkan.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.filteredProdukList.length,
              itemBuilder: (context, index) {
                final produk = controller.filteredProdukList[index];
                double hargaJual =
                    double.tryParse(produk['hargaJual'].toString()) ?? 0.0;

                return Card(
                  color: Colors.grey[300],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: produk['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(produk['image']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.image, size: 50),
                    title: Text(produk['namaProduk'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Stok: ${produk['stok']} | ${currencyFormat.format(hargaJual)}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editProduk(index, produk);
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, index, produk['id']);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit Produk'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Hapus Produk'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff181681),
        onPressed: () async {
          final result = await Get.to(TambahProdukView());
          if (result != null) {
            controller.fetchProducts(); // Refresh the product list after adding
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort Produk"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Ascending"),
                onTap: () {
                  controller.sortFilteredProdukList(ascending: true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Descending"),
                onTap: () {
                  controller.sortFilteredProdukList(ascending: false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah yakin ingin menghapus barang ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                controller.deleteProduct(productId); // Call the delete method
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editProduk(int index, Map<String, dynamic> produk) async {
    // Inisialisasi EditProdukController terlebih dahulu
    final editController = Get.put(EditProdukController());

    // Set nilai awal form dengan data produk yang ada
    editController.namaProdukController.text = produk['namaProduk'];
    editController.kodeProdukController.text = produk['kodeProduk'];
    editController.stokController.text = produk['stok'].toString();
    editController.hargaJualController.text = produk['hargaJual'].toString();
    editController.keteranganController.text = produk['keterangan'] ?? '';
    editController.kategoriController.text = produk['kategori'] ?? '';

    if (produk['image'] != null) {
      editController.setImageFromPath(produk['image']!);
    }

    final result = await Get.to(EditProdukView(
      produk: produk,
      index: index,
    ));

    if (result != null) {
      controller.products[index] = result;
      controller.fetchProducts();
    }
  }
}
