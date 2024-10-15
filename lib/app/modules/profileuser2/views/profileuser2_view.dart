import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../profileuser2/controllers/profileuser2_controller.dart';

class Profileuser2View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<
        Profileuser2Controller>(); // Mengambil controller yang diinisialisasi di binding

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Color(0xFF213F84),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 400,
              color: Color(0xFF213F84),
            ),
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
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),

                            // Obx digunakan untuk mengawasi perubahan pada selectedImagePath
                            Obx(() => CircleAvatar(
                                  radius: 55,
                                  backgroundImage: controller
                                          .selectedImagePath.value.isNotEmpty
                                      ? FileImage(File(controller
                                          .selectedImagePath
                                          .value)) // Menampilkan gambar dari file
                                      : AssetImage('assets/amaba_tokamu.jpg')
                                          as ImageProvider, // Menampilkan gambar default
                                )),
                            SizedBox(height: 20),

                            // Button untuk memilih gambar dari gallery
                            ElevatedButton(
                              onPressed: () {
                                controller
                                    .pickImage(); // Memanggil fungsi pickImage di controller
                              },
                              child: Text('Pilih Gambar'),
                            ),
                            SizedBox(height: 20),
                            menuItem('Grafik Penjualan', Icons.arrow_forward),
                            menuItem(
                                'Pengaturan Profil Toko', Icons.arrow_forward),
                            menuItem('Ganti Password', Icons.arrow_forward),
                            menuItem('Notifikasi', Icons.arrow_forward),
                            menuItem(
                                'Hapus Akun', Icons.arrow_forward, Colors.red),
                          ],
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
    );
  }

  Widget menuItem(String title, IconData icon, [Color? textColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    );
  }
}
