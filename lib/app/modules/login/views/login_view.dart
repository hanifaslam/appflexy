import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 50.0), // Increased padding on top
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Aligns items to the top
            children: [
              const Spacer(flex: 2), // Creates space at the top

              // gambar logo
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        child: Image.asset("assets/logo/flexy.png"))),
              ),

              const SizedBox(height: 40), // Increased spacing
              const Text(
                "Buka tiket Anda untuk pengalaman luar biasa!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                  height: 30), // Increased spacing between text and input
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                  height:
                      40), // Increased spacing between password input and button
              ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.PROFILE),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  backgroundColor: Color(0xFF2B47CA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Masuk",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(flex: 3), // Creates space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
