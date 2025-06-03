import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../registrasi/views/registrasi_view.dart';
import '../controllers/login_controller.dart';
import '../../../core/utils/auto_responsive.dart'; // tambahkan import ini

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DaftarKasirController>()) {
      Get.put(DaftarKasirController());
    }

    final res = AutoResponsive(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(5),
                vertical: res.hp(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: res.hp(4)), // Add space from top

                  // Logo image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(res.wp(6)),
                    child: Container(
                      height: res.wp(55),
                      width: res.wp(55),
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        child: Image.asset("assets/logo/login.png"),
                      ),
                    ),
                  ),

                  SizedBox(height: res.hp(3)), // Spacing between logo and text
                  Text(
                    "Buka tiket Anda untuk pengalaman luar biasa!",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: res.sp(16),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: res.hp(3)), // Spacing between text and input fields

                  // Email input field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(2.5)),
                    child: TextField(
                      controller: controller.emailController,
                      style: TextStyle(fontSize: res.sp(16)),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(fontSize: res.sp(16)),
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: res.sp(16),
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                        ),
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

                  SizedBox(height: res.hp(1.5)),

                  // Password input field
                  Obx(() => Padding(
                        padding: EdgeInsets.symmetric(horizontal: res.wp(2.5)),
                        child: TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: "Kata Sandi",
                            hintStyle: TextStyle(fontSize: res.sp(16)),
                            labelStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: res.sp(16),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(4)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: res.hp(1.8),
                              horizontal: res.wp(4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                      )),

                  SizedBox(height: res.hp(4)), // Spacing between password input and button
                  // Button
                  ProfileBtn(),

                  SizedBox(height: res.hp(2.5)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: TextStyle(fontSize: res.sp(16)),
                        ),
                        SizedBox(width: res.wp(2)),
                        GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.REGISTRASI);
                            },
                            child: Text(
                              'Daftar disini',
                              style: TextStyle(color: Colors.blue, fontSize: res.sp(16)),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
