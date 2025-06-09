import 'package:apptiket/app/modules/registrasi/controllers/registrasi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/utils/auto_responsive.dart';

class RegisterButton extends StatefulWidget {
  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  Color _buttonColor = const Color(0xff181681); // Initial button color
  
  // Gunakan Get.find untuk mendapatkan controller yang sudah ada
  RegistrasiController get controller => Get.find<RegistrasiController>();

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
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: res.wp(2.5)),
      child: Obx(() => ElevatedButton(
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
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(20), 
                vertical: res.hp(2),
              ),
              backgroundColor: controller.isLoading.value
                  ? _buttonColor.withOpacity(0.5)
                  : _buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(res.wp(4)),
              ),
              elevation: controller.isLoading.value ? 0 : 3,
              shadowColor: _buttonColor.withOpacity(0.3),
            ),
            child: controller.isLoading.value
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
                        'Mendaftar...',
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
                    'Daftar',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: res.sp(16),
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          )),
    );
  }
}
