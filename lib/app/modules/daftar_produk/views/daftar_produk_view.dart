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
        title: TextField(
          onChanged: updateSearchQuery,
          decoration: InputDecoration(
            hintText: 'Cari Nama Produk',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
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
          ? Center(child: Text('Tidak ada daftar produk'))
          : ListView.builder(
              itemCount: filteredProdukList.length,
              itemBuilder: (context, index) {
                final produk = filteredProdukList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/logo/logoflex.png', // Ganti path sesuai dengan ikon yang diinginkan
                        width: 40,
                        height: 40,
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
        child: Icon(Icons.add),
      ),
    );
  }

  void _showSortDialog() {
    // Sort dialog code here
  }
}
