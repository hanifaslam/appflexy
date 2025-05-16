import 'dart:io';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/pengaturan_profile_controller.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class PengaturanProfileView extends GetView<PengaturanProfileController> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.selectedImage.value = File(image.path);
    }
  }

  Widget _buildImageWidget(AutoResponsive res) {
    if (controller.selectedImage.value != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: Image.file(
          controller.selectedImage.value!,
          width: res.wp(40),
          height: res.wp(40),
          fit: BoxFit.cover,
        ),
      );
    } else if (controller.companyLogo.value.isNotEmpty) {
      final token = controller.getToken();

      return ClipRRect(
        borderRadius: BorderRadius.circular(500),
        child: CachedNetworkImage(
          imageUrl: controller.companyLogo.value.startsWith('http')
              ? controller.companyLogo.value
              : 'https://flexy.my.id/storage/${controller.companyLogo.value}',
          width: res.wp(40),
          height: res.wp(40),
          fit: BoxFit.cover,
          cacheManager: CacheManager(
            Config(
              'customCacheKey',
              stalePeriod: const Duration(days: 7),
              maxNrOfCacheObjects: 100,
              repo: JsonCacheInfoRepository(databaseName: 'customCacheKey'),
              fileService: HttpFileService(httpClient: http.Client()),
            ),
          ),
          fadeInDuration: const Duration(milliseconds: 500),
          fadeOutDuration: const Duration(milliseconds: 500),
          useOldImageOnUrlChange: true,
          cacheKey: controller.companyLogo.value,
          httpHeaders: {
            'Authorization': 'Bearer $token',
            'Connection': 'keep-alive',
            'Keep-Alive': 'timeout=100, max=1000'
          },
          errorWidget: (context, url, error) {
            print('Image error: $error');
            return const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            );
          },
        ),
      );
    } else {
      return Icon(
        Icons.add_photo_alternate,
        size: res.wp(15),
        color: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back(result: true); // Pass true to indicate refresh needed
            Get.find<HomeController>().fetchCompanyDetails(); // Refresh home data
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            children: [
              // Logo Toko
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
                    child: _buildImageWidget(res),
                  );
                }),
              ),
              Gap(res.hp(6)),

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
                    hintText: 'Nama Toko',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                      borderSide: BorderSide(color: Color(0xff181681), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                      borderSide: BorderSide(color: Color(0xff181681), width: 0.5),
                    ),
                  ),
                  style: TextStyle(fontSize: res.sp(16)),
                );
              }),
              Gap(res.hp(2)),

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
                    hintText: 'Bidang Usaha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                      borderSide: BorderSide(color: Color(0xff181681), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                      borderSide: BorderSide(color: Color(0xff181681), width: 0.5),
                    ),
                  ),
                  style: TextStyle(fontSize: res.sp(16)),
                );
              }),
              Gap(res.hp(2)),

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
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                      borderSide: BorderSide(color: Color(0xff181681), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(4)),
                      borderSide: BorderSide(color: Color(0xff181681), width: 0.5),
                    ),
                  ),
                  style: TextStyle(fontSize: res.sp(16)),
                );
              }),
              Gap(res.hp(2)),

              // Tombol Simpan
              ElevatedButton(
                onPressed: () {
                  if (controller.companyName.value.trim().isEmpty ||
                      controller.companyType.value.trim().isEmpty ||
                      controller.companyAddress.value.trim().isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Semua field harus diisi',
                      backgroundColor: Colors.red.withOpacity(0.2),
                      colorText: Colors.red,
                    );
                    return;
                  }
                  controller.updateStore();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(8), vertical: res.hp(2)),
                  backgroundColor: Color(0xff181681),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(2)),
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
    );
  }
}
