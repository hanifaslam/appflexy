import 'package:apptiket/app/modules/tambah_produk/views/tambah_produk_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DaftarProdukView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Nama Produk',
              border: InputBorder.none,
              filled: true, // Mengaktifkan pengisian
              fillColor:
                  Colors.grey[200], // Warna latar belakang sebelum disentuh
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.transparent), // Menghilangkan garis batas
                borderRadius:
                    BorderRadius.circular(50), // Mengatur radius sudut
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors
                        .transparent), // Menghilangkan garis batas saat fokus
                borderRadius:
                    BorderRadius.circular(50), // Mengatur radius sudut
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Tambahkan aksi lain di sini
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox, // Ikon kotak kosong
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan fungsi untuk menambahkan produk
          Get.to(TambahProdukView());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
