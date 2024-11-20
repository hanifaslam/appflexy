import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/registrasi/controllers/registrasi_controller.dart';
import '../routes/app_pages.dart';

class RegisterBtn extends StatefulWidget {
  @override
  _RegisterBtnState createState() => _RegisterBtnState();
}

class _RegisterBtnState extends State<RegisterBtn> {
  Color _buttonColor = const Color(0xff181681); // Initial button color
  final RegistrasiController controller =
  Get.find<RegistrasiController>(); // Retrieve the registration controller

  void _changeColor() {
    setState(() {
      _buttonColor = const Color(0xff181681)
          .withOpacity(0.2); // Change color when button is pressed
    });

    // Reset the button color to the original after 200 milliseconds
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _buttonColor = const Color(0xff181681); // Original color
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _changeColor();
      },

      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        backgroundColor: _buttonColor, // Use dynamic button color
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
          color: Colors.white, // Use Colors.white instead of Color.white
        ),
      ),
    );
  }
}