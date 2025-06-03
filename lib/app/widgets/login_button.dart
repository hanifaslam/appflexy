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
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value 
          ? null // Button disabled during loading
          : () async {
              _changeColor();

              // Get email and password from the controller
              String email = controller.emailController.text.trim();
              String password = controller.passwordController.text.trim();

              controller.login(email, password);
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        backgroundColor: controller.isLoading.value 
            ? Colors.grey.shade300 // Disabled color
            : _buttonColor, // Use dynamic button color
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: controller.isLoading.value
          // Show loading spinner when loading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff181681)),
              ),
            )
          : const Text(
              'Masuk',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Use Colors.white instead of Color.white
              ),
            ),
    ));
  }
}
