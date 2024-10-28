import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/models/struk_model.dart';

class StrukView extends StatelessWidget {
  final Receipt receipt;

  StrukView({required this.receipt});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi Berhasil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nama dan Alamat Perusahaan
            Text(receipt.companyName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(receipt.companyAddress),
            SizedBox(height: 20),

            // Tanggal Transaksi
            Text(
                'Tanggal: ${DateFormat('dd MMM yyyy').format(receipt.transactionDate)}'),

            Divider(thickness: 1),

            // Daftar Pesanan
            ...receipt.items.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item['name']} x${item['quantity']}'),
                  Text(currencyFormat.format(item['price'] * item['quantity'])),
                ],
              );
            }).toList(),

            Divider(thickness: 1),

            // Total Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(currencyFormat.format(receipt.totalAmount),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

            // Nominal Uang yang Diterima
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Uang Diterima'),
                Text(currencyFormat.format(receipt.amountPaid)),
              ],
            ),

            // Kembalian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kembalian'),
                Text(currencyFormat.format(receipt.change)),
              ],
            ),

            SizedBox(height: 20),

            // Pesan Terima Kasih
            Center(
              child: Text(
                'Terima Kasih Telah Berkunjung\nSimpan Struk Ini Sebagai Bukti Pembayaran',
                textAlign: TextAlign.center,
              ),
            ),

            Spacer(),

            // Tombol Cetak Struk
            ElevatedButton(
              onPressed: () {
                // Cetak struk logika di sini
              },
              child: Text('Cetak Struk'),
            ),

            // Tombol Kembali
            OutlinedButton(
              onPressed: () {
                Get.offAllNamed('/home'); // Kembali ke halaman home
              },
              child: Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
