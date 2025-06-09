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

    return Scaffold(      appBar: AppBar(
        backgroundColor: const Color(0xff181681),
        elevation: 1,
        title: Text(
          'Pengaturan Profil Toko',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: res.sp(20),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat mengetuk area kosong
          FocusScope.of(context).unfocus();
        },        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(5),
              vertical: res.hp(2),
            ),
            child: Column(
              children: [
                Gap(res.hp(3)),

                // Logo Toko
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Obx(() {
                      return Container(
                        width: res.wp(35),
                        height: res.wp(35),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: res.wp(0.5),
                          ),
                          borderRadius: BorderRadius.circular(res.wp(17.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: res.wp(1),
                              blurRadius: res.wp(3),
                              offset: Offset(0, res.hp(0.5)),
                            ),
                          ],
                        ),
                        child: controller.imagePath.value.isEmpty
                            ? Icon(
                                Icons.add_photo_alternate,
                                size: res.sp(18),
                                color: Colors.grey.shade600,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(res.wp(17.5)),
                                child: Image.file(
                                  File(controller.imagePath.value),
                                  fit: BoxFit.cover,
                                  width: res.wp(35),
                                  height: res.wp(35),
                                ),
                              ),
                      );
                    }),
                  ),                ),
                Gap(res.hp(4)),

                // Informasi Toko
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: TextField(
                    onChanged: (value) => controller.companyName(value),
                    decoration: InputDecoration(
                      hintText: 'Nama Toko',
                      hintStyle: TextStyle(
                        fontSize: res.sp(15),
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.store,
                        color: Colors.grey.shade600,
                        size: res.sp(20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: res.wp(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: res.wp(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: res.wp(0.2),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: res.hp(1.8),
                        horizontal: res.wp(4),
                      ),
                    ),
                    style: TextStyle(fontSize: res.sp(16)),
                  ),                ),
                Gap(res.hp(2.5)),

                // Bidang Usaha
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: TextField(
                    onChanged: (value) => controller.companyType(value),
                    decoration: InputDecoration(
                      hintText: 'Bidang Usaha',
                      hintStyle: TextStyle(
                        fontSize: res.sp(15),
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.business,
                        color: Colors.grey.shade600,
                        size: res.sp(20),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: res.wp(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: res.wp(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: res.wp(0.2),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: res.hp(1.8),
                        horizontal: res.wp(4),
                      ),
                    ),
                    style: TextStyle(fontSize: res.sp(16)),
                  ),                ),
                Gap(res.hp(2.5)),

                // Alamat Toko
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: TextField(
                    onChanged: (value) => controller.companyAddress(value),
                    maxLines: 3,
                    minLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Alamat Lengkap Toko',
                      hintStyle: TextStyle(
                        fontSize: res.sp(15),
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: res.hp(3)),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.grey.shade600,
                          size: res.sp(20),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: res.wp(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: res.wp(0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: res.wp(0.2),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: res.hp(2),
                        horizontal: res.wp(4),
                      ),
                    ),
                    style: TextStyle(fontSize: res.sp(16)),
                  ),                ),
                Gap(res.hp(4)),

                // Tombol Simpan
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                            borderRadius: res.wp(2),
                            snackPosition: SnackPosition.TOP,
                            snackStyle: SnackStyle.FLOATING,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: res.wp(8),
                          vertical: res.hp(2.2),
                        ),
                        backgroundColor: const Color(0xff181681),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                        ),
                        elevation: 3,
                        shadowColor: Color(0xff181681).withOpacity(0.3),
                      ),
                      child: Text(
                        'Simpan Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: res.sp(16),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: res.hp(3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
