import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/kasir_controller.dart';

class KasirView extends GetView<KasirController> {
  const KasirView({super.key});

  @override
  Widget build(BuildContext context) {
    int _pageIndex = 1; // Indeks halaman aktif, disesuaikan untuk KasirView

    return Scaffold(
      appBar: AppBar(
        title: const Text('KasirView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KasirView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex, // Set indeks halaman saat ini ke 1 (tengah)
        onTap: (index) {
          // Navigasi berdasarkan tab yang dipilih
          if (index == 0) {
            Get.offAllNamed(Routes.HOME); // Navigasi ke halaman HOME
          } else if (index == 1) {
            // Tab KasirView sudah aktif, tidak melakukan apa-apa
            print('Tab KasirView sudah aktif'); 
          } else if (index == 2) {
            Get.offAllNamed(Routes.SETTINGS); // Navigasi ke halaman PENJUALAN
          }
        },
      ),
    );
  }
}
