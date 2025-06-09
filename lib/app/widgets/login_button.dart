import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/login/controllers/login_controller.dart';
import '../core/utils/auto_responsive.dart';

class ProfileBtn extends StatefulWidget {
  @override
  _ProfileBtnState createState() => _ProfileBtnState();
}

class _ProfileBtnState extends State<ProfileBtn> {
  Color _buttonColor = const Color(0xff181681); // Initial button color
  
  // Gunakan Get.find untuk mendapatkan controller yang sudah ada
  LoginController get controller => Get.find<LoginController>();

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
    final res = AutoResponsive(context);
    
    return Obx(() => Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: res.wp(2.5)),
      child: ElevatedButton(
        onPressed: controller.isLoading.value 
            ? null // Button disabled during loading
            : () async {
                _changeColor();

                // Get email and password from the controller
                String email = controller.emailController.text.trim();
                String password = controller.passwordController.text.trim();

                controller.login(email, password);
              },        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(20), 
            vertical: res.hp(2)
          ),
          backgroundColor: controller.isLoading.value 
              ? _buttonColor.withOpacity(0.5) // Consistent with register button
              : _buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(4)),
          ),
          elevation: controller.isLoading.value ? 0 : 3,
          shadowColor: _buttonColor.withOpacity(0.3),
        ),child: controller.isLoading.value
            // Show loading spinner and text when loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: res.sp(20),
                    height: res.sp(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: res.wp(3)),
                  Text(
                    'Masuk...',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: res.sp(16),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                'Masuk',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: res.sp(16),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    ));
  }
}
