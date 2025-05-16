import 'package:flutter/material.dart';

class AutoResponsive {
  final BuildContext context;
  final double width;
  final double height;

  AutoResponsive(this.context)
      : width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

  double wp(double percent) => width * percent / 100;
  double hp(double percent) => height * percent / 100;
  double sp(double size) => size * (width / 375); // 375 = base width
}