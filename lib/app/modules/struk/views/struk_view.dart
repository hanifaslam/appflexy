import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/models/struk_model.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

class StrukView extends StatelessWidget {
  final Receipt receipt;

  StrukView({required this.receipt});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaksi Berhasil',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xff181681),
            fontSize: res.sp(18),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff181681)),
          onPressed: () => Get.offAllNamed('/home'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nama dan Alamat Perusahaan
              Text(
                receipt.companyName,
                style: TextStyle(
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.bold,
                  color: Color(0xff181681),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                receipt.companyAddress,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: res.sp(14)),
              ),
              SizedBox(height: res.hp(2)),

              // Tanggal Transaksi
              Text(
                'Tanggal: ${DateFormat('dd MMM yyyy').format(receipt.transactionDate)}',
                style: TextStyle(fontSize: res.sp(14)),
              ),

              Divider(thickness: 1),

              // Daftar Pesanan
              ...receipt.items.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: res.hp(0.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item['name']} x${item['quantity']}',
                          style: TextStyle(fontSize: res.sp(14))),
                      Text(currencyFormat.format(item['price'] * item['quantity']),
                          style: TextStyle(fontSize: res.sp(14))),
                    ],
                  ),
                );
              }).toList(),

              Divider(thickness: 1),

              // Total Harga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(15))),
                  Text(currencyFormat.format(receipt.totalAmount),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(15))),
                ],
              ),

              // Nominal Uang yang Diterima
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Uang Diterima', style: TextStyle(fontSize: res.sp(14))),
                  Text(currencyFormat.format(receipt.amountPaid), style: TextStyle(fontSize: res.sp(14))),
                ],
              ),

              // Kembalian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kembalian', style: TextStyle(fontSize: res.sp(14))),
                  Text(currencyFormat.format(receipt.change), style: TextStyle(fontSize: res.sp(14))),
                ],
              ),

              SizedBox(height: res.hp(2)),

              // Pesan Terima Kasih
              Center(
                child: Text(
                  'Terima Kasih Telah Berkunjung\nSimpan Struk Ini Sebagai Bukti Pembayaran',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: res.sp(14)),
                ),
              ),

              SizedBox(height: res.hp(3)),

              // Tombol Cetak Struk
              ElevatedButton(
                onPressed: () {
                  // Cetak struk logika di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff181681),
                  padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(3)),
                  ),
                ),
                child: Text('Cetak Struk', style: TextStyle(fontSize: res.sp(16), color: Colors.white)),
              ),

              SizedBox(height: res.hp(1)),

              // Tombol Kembali
              OutlinedButton(
                onPressed: () {
                  Get.offAllNamed('/home'); // Kembali ke halaman home
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                  side: BorderSide(color: Color(0xff181681)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(3)),
                  ),
                ),
                child: Text('Kembali', style: TextStyle(fontSize: res.sp(16), color: Color(0xff181681))),
              ),

              SizedBox(height: res.hp(1)),
            ],
          ),
        ),
      ),
    );
  }
}
