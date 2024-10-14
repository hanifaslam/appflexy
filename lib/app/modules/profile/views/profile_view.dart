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
              onChanged: (value) => controller.setCompanyName(value),
              decoration: InputDecoration(
                labelText: 'Nama Toko',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),

            // jenis_usaha
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => controller.companyType(value),
              decoration: InputDecoration(
                labelText: 'Bidang Usaha',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => controller.companyAddress(value),
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
                // Fungsi untuk menyimpan dan pindah ke halaman HOME
                if (controller.companyName.value.isNotEmpty &&
                    controller.companyType.value.isNotEmpty &&
                    controller.companyAddress.value.isNotEmpty) {
                  Get.offAllNamed(Routes.HOME); // Navigasi ke halaman HOME
                } else {
                  Get.snackbar(
                    'Peringatan',
                    'Harap isi semua kolom',
                    backgroundColor: Color(0xFF5C8FDA).withOpacity(0.2),
                    colorText: Color(0xFF2B47CA),
                    margin: EdgeInsets.all(16), // Margin untuk memberi jarak
                    borderRadius: 8, // Border radius untuk sudut melengkung
                    snackStyle: SnackStyle.FLOATING, // Snackbar tipe floating
                  );
                }
              },
              child: Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                backgroundColor: Color(0xFF2B47CA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
