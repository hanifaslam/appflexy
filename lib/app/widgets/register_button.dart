import 'package:apptiket/app/modules/registrasi/controllers/registrasi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterButton extends StatefulWidget {
  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  final RegistrasiController controller = Get.put(RegistrasiController());
  Color _buttonColor = const Color(0xff181681); // Initial button color

  void _changeColor() {
    setState(() {
      _buttonColor = const Color(0xff181681)
          .withOpacity(0.2); // Ubah warna saat tombol ditekan
    });

    // Kembalikan warna tombol ke keadaan semula setelah 200 milidetik
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _buttonColor = const Color(0xff181681); // Warna semula
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  _changeColor();
                  final email = controller.emailController.text;
                  final password = controller.passwordController.text;
                  final confirmPassword =
                      controller.confirmPasswordController.text;
                  final name = controller.nameController.text;
                  controller.register(email, password, confirmPassword, name);
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            backgroundColor: controller.isLoading.value
                ? _buttonColor.withOpacity(0.5)
                : _buttonColor, // Disabled look when loading
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
                  'Daftar',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ));
  }
}
