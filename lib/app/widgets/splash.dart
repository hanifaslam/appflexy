import 'package:flutter/material.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);
    
    return Scaffold(
      backgroundColor: Color(0XFF213F84),
      body: Center(
        child: Container(
          width: res.wp(50),
          height: res.wp(50),
          child: Image.asset("assets/logo/logo-splash2.png"),
        ),
      ),
    );
  }
}
