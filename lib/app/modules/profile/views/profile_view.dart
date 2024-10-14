// INI MAKSUDNYA PROFILE TOKO


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Text('Pengaturan Profil Toko'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo Toko
            GestureDetector(
              onTap: () {
                // Add functionality to upload/store a logo
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.add_photo_alternate,
                    size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            // Informasi Toko
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Toko',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Bidang Usaha',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 32),
            // Simpan Button
            ElevatedButton(
              onPressed: () {
                // Fungsi simpan dan pindah ke halaman HOME
                // Tambahkan logika penyimpanan di sini
                Get.offAllNamed(Routes.HOME); // Navigasi ke halaman HOME
              },
              child: Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF213F84),
                minimumSize: Size(double.infinity, 48), // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
