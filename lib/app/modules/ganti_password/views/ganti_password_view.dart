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
        title: Text('Ganti Password'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => controller.passwordLama.value = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password Saat Ini",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => controller.passwordBaru.value = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password Baru",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => controller.passwordBaru.value = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Konfirmasi Password Baru",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            Obx((){
              return ElevatedButton(
                onPressed: controller.isLoading.value ? null : (){
                  controller.gantiPassword();
                },
                child: controller.isLoading.value
                ? CircularProgressIndicator(color: Colors.white)
                : Text("Ganti Password"),
              );
            })
          ],
        )
      )
    );
  }
}