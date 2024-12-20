import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ganti_password_controller.dart';
// import 'package:gap/gap.dart';
// import 'package:icons_plus/icons_plus.dart';

class GantiPasswordView extends StatelessWidget {
  final GantiPasswordController controller = Get.put(GantiPasswordController());
  // const GantiPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff181681),
          elevation: 1,
          title: const Text(
            'Ganti Password',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
            },
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 250,
                    width: 250,
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      child: Image.asset("assets/logo/lupa.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) => controller.passwordLama.value = value,
                    obscureText: true,
                    decoration: new InputDecoration(
                        labelText: "Password Saat Ini",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color(0xff181681),
                              width: 0.5,
                            ))),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) => controller.passwordBaru.value = value,
                    obscureText: true,
                    decoration: new InputDecoration(
                        labelText: "Password Baru",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: 0.5,
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    onChanged: (value) => controller.passwordBaru.value = value,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: "Konfirmasi Password Baru",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color(0xff181681),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff181681),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 4,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.gantiPassword();
                          },
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Ganti Password"),
                  );
                })
              ],
            )));
  }
}
