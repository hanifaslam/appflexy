import 'dart:io';
import 'package:apptiket/app/modules/tambah_produk/views/tambah_produk_view.dart';
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
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  final box = GetStorage();
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> filteredProdukList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProdukList();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProdukList(); // Memuat data produk dari GetStorage setiap kali halaman diakses kembali
  }

  void _loadProdukList() {
    List<dynamic>? storedProdukList = box.read<List<dynamic>>('produkList');
    if (storedProdukList != null) {
      setState(() {
        produkList = List<Map<String, dynamic>>.from(storedProdukList);
        filteredProdukList = produkList;
      });
    }
  }

  void _saveProdukList() {
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
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _showSortDialog,
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
                      title: Text(
                        produk['namaProduk'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currencyFormat.format(produk['hargaJual']),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Stok: ${produk['stok']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            produkList.removeAt(index);
                            _saveProdukList();
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff181681),
        onPressed: () async {
          final result = await Get.to(TambahProdukView());
          if (result != null) {
            setState(() {
              produkList.add(result);
              _saveProdukList();
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

  void _showSortDialog() {
    // Sort dialog code here
  }
}
