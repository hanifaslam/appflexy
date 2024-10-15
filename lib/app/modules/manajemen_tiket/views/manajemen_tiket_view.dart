import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manajemen_tiket_controller.dart';

class ManajemenTiketView extends GetView<ManajemenTiketController> {
  const ManajemenTiketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ManajemenTiketView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ini page sementara!',
              style: TextStyle(fontSize: 20),
            ),

            // tombol sementara untuk balik ke home
            const SizedBox(height: 20), // Jarak antara teks dan tombol
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed(Routes.HOME); // Navigasi ke route
              },
              child: const Text('Balik ke Home!'),
            ),
          ],
        ),
      ),
    );
  }
}
