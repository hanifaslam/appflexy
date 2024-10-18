import 'package:apptiket/app/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
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
                vertical: 50.0, // Adjust top padding if needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Align items to the center horizontally
                children: [
                  const SizedBox(height: 50), // Add space from top

                  // Logo image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        child: Image.asset("assets/logo/logoflex.png"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40), // Spacing between logo and text
                  const Text(
                    "Buka tiket Anda untuk pengalaman luar biasa!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30), // Spacing between text and input fields

                  // Email input field
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xFF84AFC2)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Password input field
                  Obx(() => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            hintText: "Password",
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

                  const SizedBox(height: 40), // Spacing between password input and button

                  // Button
                  ProfileBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
