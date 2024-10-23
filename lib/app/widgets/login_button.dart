import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/login/controllers/login_controller.dart';
import '../routes/app_pages.dart';

class ProfileBtn extends StatefulWidget {
  @override
  _ProfileBtnState createState() => _ProfileBtnState();
}

class _ProfileBtnState extends State<ProfileBtn> {
  Color _buttonColor = const Color(0xFF2B47C4); // Warna awal tombol
  final LoginController controller =
      Get.find<LoginController>(); // Mendapatkan controller

  void _changeColor() {
    setState(() {
      _buttonColor = const Color(0xFF5C8FDA)
          .withOpacity(0.2); // Mengubah warna ketika tombol ditekan
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        _changeColor();

        // Mengambil email dan password dari controller
        String email = controller.emailController.text.trim();
        String password = controller.passwordController.text.trim();

        // Memastikan email dan password tidak kosong
        if (email.isNotEmpty && password.isNotEmpty) {
          // Panggil API login melalui controller dan tunggu hasilnya
          var response = await controller.login(email, password);

          if (response['status'] == 'success') {
            // Jika login berhasil, pindah ke halaman profil
            Get.offAllNamed(Routes.PROFILE);
          } else {
            // Jika login gagal, tampilkan pesan kesalahan
            Get.snackbar(
              'Login Gagal',
              response['message'] ?? 'Email atau kata sandi salah',
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          // Jika email atau password kosong, tampilkan pesan kesalahan
          Get.snackbar(
            'Kesalahan',
            'Masukkan email dan kata sandi',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        backgroundColor: _buttonColor, // Menggunakan warna tombol yang dinamis
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        'Simpan',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
