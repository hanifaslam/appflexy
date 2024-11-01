import 'dart:io'; // Untuk menggunakan File
import 'package:apptiket/app/modules/edit_produk/views/edit_produk_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DaftarProdukView extends StatefulWidget {
  @override
  _DaftarProdukViewState createState() => _DaftarProdukViewState();
}

class _DaftarProdukViewState extends State<DaftarProdukView> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final box = GetStorage(); // Inisialisasi GetStorage
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> filteredProdukList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProdukList(); // Load data saat initState
  }

  void _loadProdukList() {
    // Memuat daftar produk dari GetStorage
    List<dynamic>? storedProdukList = box.read<List<dynamic>>('produkList');
    if (storedProdukList != null) {
      produkList = List<Map<String, dynamic>>.from(storedProdukList);
      filteredProdukList = produkList;
    }
  }

  void _saveProdukList() {
    // Menyimpan daftar produk ke GetStorage
    box.write('produkList', produkList);
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredProdukList = produkList
          .where((produk) =>
              produk['namaProduk'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showSortDialog() {
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
                  setState(() {
                    filteredProdukList.sort(
                        (a, b) => a['namaProduk'].compareTo(b['namaProduk']));
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Descending"),
                onTap: () {
                  setState(() {
                    filteredProdukList.sort(
                        (a, b) => b['namaProduk'].compareTo(a['namaProduk']));
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
            onChanged: updateSearchQuery,
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
              _showSortDialog();
            },
          ),
        ],
      ),
      body: filteredProdukList.isEmpty
          ? Container(
              child: Center(
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
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: filteredProdukList.length,
                  itemBuilder: (context, index) {
                    final produk = filteredProdukList[index];
                    double hargaJual =
                        double.tryParse(produk['hargaJual'].toString()) ??
                            0.0; // Konversi hargaJual ke double

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
                                  File(produk['image']), // Tampilkan gambar
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.image, size: 50),
                        title: Text(produk['namaProduk'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Stok: ${produk['stok']} | ${currencyFormat.format(hargaJual)}', // Tampilkan harga yang diformat
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editProduk(index, produk);
                            } else if (value == 'delete') {
                              _showDeleteDialog(index);
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
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff181681),
        onPressed: () async {
          final result = await Get.to(EditProdukView());
          if (result != null) {
            setState(() {
              produkList.add(result);
              _saveProdukList(); // Simpan setelah menambah produk
              updateSearchQuery(searchQuery);
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showDeleteDialog(int index) {
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
                setState(() {
                  produkList.removeAt(index);
                  _saveProdukList(); // Simpan setelah menghapus produk
                  updateSearchQuery(searchQuery);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editProduk(int index, Map<String, dynamic> produk) async {
    final result = await Get.to(EditProdukView(
      produk: produk,
      index: index,
    ));
    if (result != null) {
      setState(() {
        produkList[index] = result;
        _saveProdukList(); // Simpan setelah mengedit produk
        updateSearchQuery(searchQuery);
      });
    }
  }
}
