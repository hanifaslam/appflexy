import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/pengaturan_profile_controller.dart';
import '../../../routes/app_pages.dart'; // Pastikan Anda mengimpor Routes jika belum ada

class PengaturanProfileView extends GetView<PengaturanProfileController> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.setCompanyLogo(image.path); // Simpan path logo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 29),
          child: Text(
            'Pengaturan Profil Toko',
            style: TextStyle(fontFamily: 'Montserrat-VariableFont_wght'),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Kembali ke halaman sebelumnya (Profileuser2)
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat mengetuk area kosong
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                      child: controller.companyLogo.value.isEmpty
                          ? const Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.grey,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Image.file(
                                File(controller.companyLogo.value),
                                fit: BoxFit.cover, // Gambar memenuhi container
                                width: 150,
                                height: 150,
                              ),
                            ),
                    );
                  }),
                ),
                const Gap(50),

                // Informasi Toko
                TextField(
                  onChanged: (value) => controller.setCompanyName(value),
                  decoration: InputDecoration(
                    hintText: 'Nama Toko',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Bidang Usaha
                TextField(
                  onChanged: (value) => controller.companyType(value),
                  decoration: InputDecoration(
                    hintText: 'Bidang Usaha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Alamat Toko
                TextField(
                  onChanged: (value) => controller.companyAddress(value),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: () {
                    if (controller.companyName.value.isNotEmpty &&
                        controller.companyType.value.isNotEmpty &&
                        controller.companyAddress.value.isNotEmpty &&
                        controller.companyLogo.value.isNotEmpty) {
                      Get.offAllNamed(Routes.PROFILEUSER2); // Navigasi ke halaman Profileuser2
                    } else {
                      Get.snackbar(
                        'Peringatan',
                        'Harap isi semua kolom',
                        backgroundColor: const Color(0xFF5C8FDA).withOpacity(0.2),
                        colorText: const Color(0xFF2B47CA),
                        margin: const EdgeInsets.all(16), // Margin untuk memberi jarak
                        borderRadius: 8, // Sudut melengkung
                        snackStyle: SnackStyle.FLOATING, // Snackbar tipe floating
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    backgroundColor: const Color(0xff181681),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
