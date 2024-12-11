import 'dart:io';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrisPaymentView extends StatelessWidget {
  // Fungsi untuk mengambil path gambar QR Code yang tersimpan di SharedPreferences
  Future<File?> getQrCodeImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath =
        prefs.getString('qrCodePath'); // Ambil path gambar yang disimpan
    if (savedPath != null) {
      final file = File(savedPath);
      if (await file.exists()) {
        return file; // Kembalikan file jika ada
      }
    }
    return null; // Jika tidak ada, kembalikan null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRIS Payment'),
        centerTitle: true,
      ),
      body: FutureBuilder<File?>(
        future: getQrCodeImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    snapshot.data!,
                    width: MediaQuery.of(context).size.width *
                        0.9, // 80% dari lebar layar
                    height: MediaQuery.of(context).size.height *
                        0.6, // 40% dari tinggi layar
                    fit: BoxFit
                        .contain, // Menyesuaikan gambar agar pas dalam ukuran tersebut
                  ),
                  const SizedBox(height: 20), // Spasi antara gambar dan tombol
                  ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.DAFTAR_KASIR);
                      // Logika untuk verifikasi pembayaran
                      // Misalnya menampilkan pesan atau mengarahkan ke halaman lain
                      print("Verifikasi Pembayaran Dimulai");
                    },
                    child: const Text('Verifikasi Pembayaran',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor:
                          Color(0xff181681), // Tombol berwarna hijau
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'QR Code tidak ditemukan. Silakan unggah QR Code di pengaturan.',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QrisPaymentView(),
  ));
}
