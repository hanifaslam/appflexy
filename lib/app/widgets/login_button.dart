import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/login/controllers/login_controller.dart';

class ProfileBtn extends StatefulWidget {
  @override
  _ProfileBtnState createState() => _ProfileBtnState();
}

class _ProfileBtnState extends State<ProfileBtn> {
  Color _buttonColor = const Color(0xff181681); // Initial button color
  final LoginController controller =
      Get.find<LoginController>(); // Retrieve the controller

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
    return ElevatedButton(
      onPressed: () async {
        _changeColor();

        // Get email and password from the controller
        String email = controller.emailController.text.trim();
        String password = controller.passwordController.text.trim();

        controller.login(email, password);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        backgroundColor: _buttonColor, // Use dynamic button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        'Masuk',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Use Colors.white instead of Color.white
        ),
      ),
    );
  }
}
