import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KasirView extends StatelessWidget {
  final List<Map<String, dynamic>> pesananList;

  KasirView({required this.pesananList});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pesanan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: pesananList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada pesanan.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: pesananList.length,
              itemBuilder: (context, index) {
                final produk = pesananList[index];
                final hargaJual = produk['hargaJual'];

                // Memeriksa apakah hargaJual adalah angka dan tidak null
                final formattedPrice = (hargaJual != null && hargaJual is num)
                    ? currencyFormat.format(hargaJual)
                    : 'Harga tidak tersedia';

                return ListTile(
                  leading: Icon(Icons.shopping_bag, size: 40),
                  title: Text(produk['namaProduk']),
                  subtitle: Text('Harga: $formattedPrice'),
                  trailing: Text('Qty: 1'), // Asumsi 1 pesanan per produk
                );
              },
            ),
    );
  }
}
