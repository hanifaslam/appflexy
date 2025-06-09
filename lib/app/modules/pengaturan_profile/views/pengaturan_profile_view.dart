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
import 'package:apptiket/app/core/utils/auto_responsive.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/modules/profileuser2/controllers/profileuser2_controller.dart';

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
        borderRadius: BorderRadius.circular(res.wp(17.5)),
        child: Image.file(
          controller.selectedImage.value!,
          width: res.wp(35),
          height: res.wp(35),
          fit: BoxFit.cover,
        ),
      );
    } else if (controller.companyLogo.value.isNotEmpty) {
      final token = controller.getToken();

      return ClipRRect(
        borderRadius: BorderRadius.circular(res.wp(17.5)),
        child: CachedNetworkImage(
          imageUrl: controller.companyLogo.value.startsWith('http')
              ? controller.companyLogo.value
              : ApiConstants.getStorageUrl(controller.companyLogo.value),
          width: res.wp(35),
          height: res.wp(35),
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
          },          errorWidget: (context, url, error) {
            print('Image error: $error');
            return Icon(
              Icons.error_outline,
              size: res.sp(25),
              color: Colors.red,
            );
          },
        ),
      );
    } else {
      return Icon(
        Icons.add_photo_alternate,
        size: res.sp(18),
        color: Colors.grey.shade600,
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
        ),        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Colors.white,
            size: res.sp(20),
          ),
          onPressed: () {
            // Always navigate back to profileuser2 view
            if (Get.isRegistered<Profileuser2Controller>()) {
              final profileController = Get.find<Profileuser2Controller>();
              profileController.fetchCompanyDetails();
            }
            
            // Update home controller data
            Get.find<HomeController>().fetchCompanyDetails();
            
            // Use offNamed instead of back for more reliable navigation
            Get.offNamed(Routes.PROFILEUSER2);
          },
        ),
      ),      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(5),
            vertical: res.hp(2),
          ),
          child: Column(
            children: [              Gap(res.hp(3)),

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
                      child: _buildImageWidget(res),
                    );
                  }),
                ),
              ),              Gap(res.hp(4)),

              // Nama Toko
              Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: TextField(
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
                  ),
                );
              }),              Gap(res.hp(2.5)),

              // Bidang Usaha
              Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: TextField(
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
                  ),
                );
              }),              Gap(res.hp(2.5)),

              // Alamat Toko
              Obx(() {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                  child: TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: controller.companyAddress.value,
                        selection: TextSelection.collapsed(
                          offset: controller.companyAddress.value.length,
                        ),
                      ),
                    ),
                    onChanged: (value) => controller.companyAddress.value = value,
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
                  ),
                );
              }),              Gap(res.hp(4)),

              // Tombol Simpan
              Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.companyName.value.trim().isEmpty ||
                          controller.companyType.value.trim().isEmpty ||
                          controller.companyAddress.value.trim().isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Semua field harus diisi',
                          backgroundColor: Colors.red.withOpacity(0.2),
                          colorText: Colors.red,
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.all(res.wp(4)),
                        );
                        return;
                      }
                      controller.updateStore();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: res.wp(8), 
                        vertical: res.hp(2.2),
                      ),
                      backgroundColor: Color(0xff181681),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                      ),
                      elevation: 3,
                      shadowColor: Color(0xff181681).withOpacity(0.3),
                    ),
                    child: Text(
                      'Simpan Perubahan',
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
    );
  }
}
