import 'package:apptiket/app/modules/registrasi/controllers/registrasi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apptiket/app/widgets/register_button.dart';

import '../../../routes/app_pages.dart';
import '../../../core/utils/auto_responsive.dart'; // tambahkan import ini

class RegistrasiView extends GetView<RegistrasiController> {
  final RegistrasiController controller = Get.put(RegistrasiController());

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    // Gunakan WillPopScope untuk menangani tombol back dari hardware
    return WillPopScope(
      // Ketika tombol back ditekan, kembali ke halaman login
      onWillPop: () async {
        Get.offAllNamed(Routes.LOGIN);
        return false; // Mencegah navigasi default
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: res.hp(8), // Responsive toolbar height
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Kembali ke halaman login ketika tombol back di AppBar ditekan
              Get.offAllNamed(Routes.LOGIN);
            },
          ),
          title: Text(
            'Register',
            style: TextStyle(fontSize: res.sp(18)),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(5),
                vertical: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: res.hp(3)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(res.wp(7)),
                    child: Container(
                      height: res.wp(55),
                      width: res.wp(55),
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        child: Image.asset("assets/logo/register.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(3)),
                  // Name input field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                    child: TextField(
                      controller: controller.nameController,
                      style: TextStyle(fontSize: res.sp(16)),
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        hintStyle: TextStyle(fontSize: res.sp(16)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(4)),
                          borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: res.hp(1.8),
                          horizontal: res.wp(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
                  // Email input field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                    child: TextField(
                      controller: controller.emailController,
                      style: TextStyle(fontSize: res.sp(16)),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: res.sp(16)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(4)),
                          borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: res.hp(1.8),
                          horizontal: res.wp(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
                  // Password input field with visibility toggle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                    child: Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: 'Kata Sandi',
                            hintStyle: TextStyle(fontSize: res.sp(16)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(4)),
                              borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: res.hp(1.8),
                              horizontal: res.wp(4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(controller.isPasswordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: res.hp(2)),
                  // Confirm Password input field with visibility toggle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                    child: Obx(() => TextField(
                          controller: controller.confirmPasswordController,
                          obscureText: controller.isConfirmPasswordHidden.value,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi Kata Sandi',
                            hintStyle: TextStyle(fontSize: res.sp(16)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(4)),
                              borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: res.hp(1.8),
                              horizontal: res.wp(4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(controller.isConfirmPasswordHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: controller.toggleConfirmPasswordVisibility,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: res.hp(4)),
                  RegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
