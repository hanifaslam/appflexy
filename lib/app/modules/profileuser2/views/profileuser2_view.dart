import 'dart:io'; // Ini tetap diimport untuk antisipasi penggunaan FileImage di kemudian hari
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../profileuser2/controllers/profileuser2_controller.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:apptiket/app/routes/app_pages.dart';

class Profileuser2View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Profileuser2Controller>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF213F84),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background warna dengan lingkaran dekorasi
            Container(
              height: 400,
              color: Color(0xFF213F84),
              child: Stack(
                children: [
                  Positioned(top: 20, left: 50, child: circleDecoration(30, 0.4)),
                  Positioned(top: 70, left: 20, child: circleDecoration(20, 0.6)),
                  Positioned(top: 100, left: 90, child: circleDecoration(15, 0.8)),
                  Positioned(top: 50, left: 30, child: circleDecoration(80, 0.5)),
                  Positioned(top: 20, right: 50, child: circleDecoration(100, 0.7)),
                  Positioned(top: 120, right: 10, child: circleDecoration(60, 1.0)),
                  Positioned(top: 150, left: 20, child: circleDecoration(40, 0.8)),
                ],
              ),
            ),
            // Kotak melengkung dan isi profil
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 60, bottom: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFEDEDED),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Aqua Bliss Pool',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            // Penjualan (pengeluaran dihapus dan penjualan di tengah)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.arrow_downward, color: Colors.green, size: 30),
                                      SizedBox(height: 5),
                                      Text(
                                        'Penjualan',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Rp 4.000.000',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // List Menu dengan navigasi
                            menuItem('Grafik Penjualan', Icons.arrow_forward, () {
                              // Navigasi ke halaman Grafik Penjualan
                              //Get.toNamed(Routes.GRAFIK_PENJUALAN);
                            }),
                            menuItem('Pengaturan Profil Toko', Icons.arrow_forward, () {
                              // Navigasi ke halaman Pengaturan Profil Toko
                             // Get.toNamed(Routes.PENGATURAN_PROFIL_TOKO);
                            }),
                            menuItem('Ganti Password', Icons.arrow_forward, () {
                              // Navigasi ke halaman Ganti Password
                              //Get.toNamed(Routes.GANTI_PASSWORD);
                            }),
                            menuItem('Notifikasi', Icons.arrow_forward, () {
                              // Navigasi ke halaman Notifikasi
                              //Get.toNamed(Routes.NOTIFIKASI);
                            }),
                            menuItem('Hapus Akun', Icons.arrow_forward, () {
                              // Navigasi ke halaman Hapus Akun
                              //Get.toNamed(Routes.HAPUS_AKUN);
                            }, Colors.red),
                          ],
                        ),
                      ),
                      // Setengah lingkaran di atas kotakan
                      Positioned(
                        top: -58, // Posisi setengah lingkaran
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 125,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFFEDEDED),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Foto Profil di atas setengah lingkaran
                      Positioned(
                        top: -50, // Naikin foto profil biar di atas setengah lingkaran
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Obx(
                            () => CircleAvatar(
                              radius: 55,
                              backgroundImage: controller.selectedImagePath.value.isNotEmpty
                                  ? FileImage(File(controller.selectedImagePath.value))
                                  : AssetImage('assets/logo/logoflex.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar( // Tambahkan CustomNavigationBar di sini
        currentIndex: 2, // misalnya, tab profil (indeks 2)
        onTap: (index) {
          // Navigasi berdasarkan tab yang ditekan
          if (index == 0) {
            Get.offAllNamed(Routes.HOME); // Navigasi ke halaman Home
          } else if (index == 1) {
            Get.offAllNamed(Routes.KASIR); // Navigasi ke halaman Kasir
          } else if (index == 2) {
            // Tetap di halaman profil
          }
        },
      ),
    );
  }

  // Widget lingkaran untuk dekorasi background
  Widget circleDecoration(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFADD8E7).withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  // Widget untuk menu item dengan onTap untuk navigasi
  Widget menuItem(String title, IconData icon, Function onTap, [Color? textColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: textColor ?? Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
