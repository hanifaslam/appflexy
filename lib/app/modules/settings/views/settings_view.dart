import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    int _pageIndex = 3; // Indeks halaman aktif, sesuaikan dengan urutan tab

    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SettingsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex, // Set indeks halaman saat ini
        onTap: (index) {
          // Navigasi berdasarkan tab yang dipilih
          if (index == 0) {
            Get.offAllNamed(Routes.HOME); // Navigasi ke halaman HOME
          } else if (index == 1) {
            Get.offAllNamed(Routes.KASIR); // Navigasi ke halaman KASIR
          } else if (index == 2) {
            Get.offAllNamed(Routes.SETTINGS); // Navigasi ke halaman PENJUALAN
          } else if (index == 3) {
            // Tab SettingsView sudah aktif, tidak melakukan apa-apa
            print('Tab SettingsView sudah aktif'); 
          }
        },
      ),
    );
  }
}
