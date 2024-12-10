import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apptiket/app/modules/registrasi/controllers/registrasi_controller.dart';
import 'package:apptiket/app/widgets/register_button.dart'; // Import RegisterBtn widget

class RegistrasiView extends GetView<RegistrasiController> {
  final RegistrasiController controller =
  Get.put(RegistrasiController()); // Initialize the registration controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ), // Set the title of the page
      ),
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat mengetuk area kosong
          FocusScope.of(context).unfocus();
        },
        child: Align(
          alignment: Alignment.topCenter, // Align content to the top
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 0.0, // Adjust top padding if needed
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               // Add space from top
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 300,
                    width: 300,
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      child: Image.asset("assets/logo/register.png"),
                    ),
                  ),
                ),

                
                const SizedBox(
                    height: 30), // Spacing between text and input fields
                // Name input field (New addition)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller:
                    controller.nameController, // Use controller for name
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Email input field
                Padding(
                  padding: const EdgeInsets.symmetric (horizontal: 15),
                  child: TextField(
                    controller:
                    controller.emailController, // Use controller for email
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Password input field with visibility toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(() => TextField(
                    controller: controller
                        .passwordController, // Use controller for password
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                        const BorderSide(color: Color(0xFF84AFC2)),
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
                SizedBox(height: 16),

                // Confirm Password input field with visibility toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(() => TextField(
                    controller: controller
                        .confirmPasswordController, // Use controller for confirm password
                    obscureText: controller.isConfirmPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                        const BorderSide(color: Color(0xFF84AFC2)),
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
                SizedBox(height: 40),
                // Register button that triggers registration logic
                RegisterBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
