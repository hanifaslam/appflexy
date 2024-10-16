import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.setCompanyLogo(image.path); // Simpan path logo toko
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            'Pengaturan Profil Toko',
            style: TextStyle(fontFamily: 'Montserrat-VariableFont_wght'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Logo Toko
              GestureDetector(
                onTap: _pickImage,
                child: Obx(() {
                  return Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: controller.companyLogoPath.value.isEmpty
                        ? Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: Colors.grey,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.file(
                              File(controller.companyLogoPath.value),
                              fit: BoxFit
                                  .cover, // Agar gambar memenuhi container
                              width: 100,
                              height: 100,
                            ),
                          ),
                  );
                }),
              ),

              SizedBox(height: 25),
              // Informasi Toko
              TextField(
                onChanged: (value) => controller.setCompanyName(value),
                decoration: InputDecoration(
                  labelText: 'Nama Toko',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              // jenis_usaha
              SizedBox(height: 16),
              TextField(
                onChanged: (value) => controller.companyType(value),
                decoration: InputDecoration(
                  labelText: 'Bidang Usaha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                onChanged: (value) => controller.companyAddress(value),
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 32),
              // Simpan Button
              ElevatedButton(
                onPressed: () {
                  // Fungsi untuk menyimpan dan pindah ke halaman HOME
                  if (controller.companyName.value.isNotEmpty &&
                      controller.companyType.value.isNotEmpty &&
                      controller.companyAddress.value.isNotEmpty &&
                      controller.companyLogoPath.value.isNotEmpty) {
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
