import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class ProfileBtn extends StatefulWidget {
  @override
  _ProfileBtnState createState() => _ProfileBtnState();
}

class _ProfileBtnState extends State<ProfileBtn> {
  Color _buttonColor = const Color(0xFF2B47C4); // Initial color

  void _changeColor() {
    setState(() {
      _buttonColor = Color(0xFF5C8FDA).withOpacity(0.2); // Change color on tap
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _changeColor();
        Get.offAllNamed(Routes.PROFILE); // Navigate after changing color
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        backgroundColor: _buttonColor, // Use dynamic color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        'Simpan',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
