import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/pengaturan_profile_controller.dart';

class PengaturanProfileView extends GetView<PengaturanProfileController> {
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.companyLogo.value = image.path; // Simpan path logo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff181681),
        elevation: 1,
        title: const Text(
          'Pengaturan Profil Toko',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
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
                              fit: BoxFit.cover,
                            ),
                          ),
                  );
                }),
              ),
              const Gap(50),

              // Nama Toko
              Obx(() {
                return TextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: controller.companyName.value,
                      selection: TextSelection.collapsed(
                        offset: controller.companyName.value.length,
                      ),
                    ),
                  ),
                  onChanged: (value) => controller.companyName.value = value,
                  decoration: InputDecoration(
                    hintText: 'Nama Toko', // Ganti labelText dengan hintText
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Sesuaikan border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide:
                          BorderSide(color: Color(0xff181681), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff181681), width: 0.5),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Bidang Usaha
              Obx(() {
                return TextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: controller.companyType.value,
                      selection: TextSelection.collapsed(
                        offset: controller.companyType.value.length,
                      ),
                    ),
                  ),
                  onChanged: (value) => controller.companyType.value = value,
                  decoration: InputDecoration(
                    hintText: 'Bidang Usaha', // Petunjuk untuk input
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Border yang melengkung
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide:
                          BorderSide(color: Color(0xff181681), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff181681), width: 0.5),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Alamat Toko
              Obx(() {
                return TextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: controller.companyAddress.value,
                      selection: TextSelection.collapsed(
                        offset: controller.companyAddress.value.length,
                      ),
                    ),
                  ),
                  onChanged: (value) => controller.companyAddress.value = value,
                  maxLines: 2, // Membatasi input hingga dua baris
                  decoration: InputDecoration(
                    hintText: 'Alamat', // Petunjuk untuk input
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Border yang melengkung
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide:
                          BorderSide(color: Color(0xff181681), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff181681), width: 0.5),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Tombol Simpan
              ElevatedButton(
                onPressed: () {
                  if (controller.companyName.value.isNotEmpty &&
                      controller.companyType.value.isNotEmpty &&
                      controller.companyAddress.value.isNotEmpty &&
                      controller.companyLogo.value.isNotEmpty) {
                    controller.updateStore(); // Memperbarui profil
                  } else {
                    Get.snackbar(
                      'Peringatan',
                      'Harap isi semua kolom',
                      backgroundColor: Colors.red.withOpacity(0.2),
                      colorText: Colors.red,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Color(0xff181681),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
