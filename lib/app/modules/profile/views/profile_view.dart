import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class ProfileView extends GetView<ProfileController> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.imagePath.value = (image.path); // Simpan path logo toko
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: res.hp(3.5)),
          child: Text(
            'Pengaturan Profil Toko',
            style: TextStyle(
              fontFamily: 'Montserrat-VariableFont_wght',
              fontWeight: FontWeight.bold,
              color: Color(0xff181681),
              fontSize: res.sp(18),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat mengetuk area kosong
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(res.wp(4)),
            child: Column(
              children: [
                // Logo Toko
                Gap(res.hp(2)),
                GestureDetector(
                  onTap: _pickImage,
                  child: Obx(() {
                    return Container(
                      width: res.wp(40),
                      height: res.wp(40),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: controller.imagePath.value.isEmpty
                          ? Icon(
                              Icons.add_photo_alternate,
                              size: res.wp(15),
                              color: Colors.grey,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Image.file(
                                File(controller.imagePath.value),
                                fit: BoxFit.cover,
                                width: res.wp(40),
                                height: res.wp(40),
                              ),
                            ),
                    );
                  }),
                ),
                Gap(res.hp(6)),

                // Informasi Toko
                TextField(
                  onChanged: (value) => controller.companyName(value),
                  decoration: InputDecoration(
                    hintText: 'Nama Toko',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                  ),
                  style: TextStyle(fontSize: res.sp(16)),
                ),
                Gap(res.hp(3)),

                // Bidang Usaha
                TextField(
                  onChanged: (value) => controller.companyType(value),
                  decoration: InputDecoration(
                    hintText: 'Bidang Usaha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                  ),
                  style: TextStyle(fontSize: res.sp(16)),
                ),
                Gap(res.hp(3)),

                // Alamat Toko
                TextField(
                  onChanged: (value) => controller.companyAddress(value),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                  ),
                  style: TextStyle(fontSize: res.sp(16)),
                ),
                Gap(res.hp(3)),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: () {
                    if (controller.companyName.value.isNotEmpty &&
                        controller.companyType.value.isNotEmpty &&
                        controller.companyAddress.value.isNotEmpty) {
                      // Simpan data ke GetStorage
                      controller.saveToStorage();

                      // Kirim data ke API
                      controller.saveProfileToApi();

                      // Navigasi ke halaman HOME jika berhasil
                      Get.offAllNamed(Routes.HOME);
                    } else {
                      Get.snackbar(
                        'Peringatan',
                        'Harap isi semua kolom teks',
                        backgroundColor:
                            const Color(0xFF5C8FDA).withOpacity(0.2),
                        colorText: const Color(0xFF2B47CA),
                        margin: EdgeInsets.all(res.wp(4)),
                        borderRadius: 8,
                        snackStyle: SnackStyle.FLOATING,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: res.wp(20), vertical: res.hp(2.5)),
                    backgroundColor: const Color(0xff181681),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: res.sp(16)),
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
