import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    int _pageIndex = 2; // Indeks halaman aktif, sesuaikan dengan urutan tab
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xff181681),
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(res.wp(5)),
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Color(0xff181681)),
            title: Text('Profil Toko', style: TextStyle(fontSize: res.sp(16))),
            trailing: Icon(Icons.arrow_forward_ios, size: res.sp(16)),
            onTap: () => Get.toNamed(Routes.PENGATURAN_PROFILE),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock, color: Color(0xff181681)),
            title: Text('Ganti Password', style: TextStyle(fontSize: res.sp(16))),
            trailing: Icon(Icons.arrow_forward_ios, size: res.sp(16)),
            onTap: () => Get.toNamed(Routes.GANTI_PASSWORD),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.qr_code, color: Color(0xff181681)),
            title: Text('Pengaturan QRIS', style: TextStyle(fontSize: res.sp(16))),
            trailing: Icon(Icons.arrow_forward_ios, size: res.sp(16)),
            onTap: () => Get.toNamed(Routes.SETTING_Q_R_I_S),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Keluar', style: TextStyle(fontSize: res.sp(16), color: Colors.red)),
            onTap: () {
              // Tambahkan logika logout di sini jika diperlukan
              Get.offAllNamed(Routes.LOGIN);
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex, // Set indeks halaman saat ini
        onTap: (index) {
          // Navigasi berdasarkan tab yang dipilih
          if (index == 0) {
            Get.offNamed(Routes.HOME); // Navigasi ke halaman HOME
          } else if (index == 1) {
            Get.offNamed(Routes.KASIR); // Navigasi ke halaman KASIR
          } else if (index == 2) {
            Get.offNamed(Routes.SETTINGS); // Navigasi ke halaman PENJUALAN
          } else if (index == 3) {
            // Tab SettingsView sudah aktif, tidak melakukan apa-apa
            print('Tab SettingsView sudah aktif');
          }
        },
      ),
    );
  }
}
