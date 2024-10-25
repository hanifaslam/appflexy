import 'dart:io';
import 'package:apptiket/app/modules/kasir/views/kasir_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DaftarKasirView extends StatefulWidget {
  @override
  _DaftarKasirViewState createState() => _DaftarKasirViewState();
}

class _DaftarKasirViewState extends State<DaftarKasirView> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final box = GetStorage();
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> filteredProdukList = [];
  List<Map<String, dynamic>> pesananList = [];
  String searchQuery = '';
  int pesananCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProdukList();
  }

  void _loadProdukList() {
    // Memuat daftar produk dari GetStorage
    List<dynamic>? storedProdukList = box.read<List<dynamic>>('produkList');
    if (storedProdukList != null) {
      produkList = List<Map<String, dynamic>>.from(storedProdukList);
      filteredProdukList = produkList;
    }
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

  void addToPesanan(Map<String, dynamic> produk) {
    setState(() {
      pesananList.add(produk);
      pesananCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: filteredProdukList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada daftar produk yang dapat ditampilkan.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: filteredProdukList.length,
                itemBuilder: (context, index) {
                  final produk = filteredProdukList[index];
                  double hargaJual =
                      double.tryParse(produk['hargaJual'].toString()) ?? 0.0;

                  return Card(
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
                          'Stok: ${produk['stok']} | ${currencyFormat.format(hargaJual)}'),
                      onTap: () {
                        addToPesanan(produk);
                        Get.snackbar('Pesanan',
                            '${produk['namaProduk']} ditambahkan ke pesanan.');
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => KasirView(pesananList: pesananList));
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
