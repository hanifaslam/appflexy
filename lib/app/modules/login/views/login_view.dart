import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../registrasi/views/registrasi_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DaftarKasirController>()) {
      Get.put(DaftarKasirController());
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat mengetuk area kosong
          FocusScope.of(context).unfocus();
        },
        child: Align(
          alignment: Alignment.topCenter, // Align content to the top
          child: SingleChildScrollView(
            // Ensures content is scrollable if needed
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 80.0, // Adjust top padding if needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Align items to the center horizontally
                children: [
                  const SizedBox(height: 40), // Add space from top

                  // Logo image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 250,
                      width: 250,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        child: Image.asset("assets/logo/login.png"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30), // Spacing between logo and text
                  Text(
                    "Buka tiket Anda untuk pengalaman luar biasa!",
                    style: TextStyle(
                      fontFamily: 'Inter', // Custom font family
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                      height: 30), // Spacing between text and input fields

                  // Email input field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          fontFamily: 'Inter', // Apply custom font
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Color(0xFF84AFC2)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Password input field
                  Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            labelText: "Kata Sandi",
                            labelStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
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

                  const SizedBox(
                      height: 40), // Spacing between password input and button
                  // Button
                  ProfileBtn(),

                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.to(() => RegistrasiView());
                            },
                            child: Text(
                              'Daftar disini',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
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
