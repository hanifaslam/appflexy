import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: RichText(
          text: TextSpan(
              text: "Flexy",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              )),
        ),
        backgroundColor: Color(0xff365194),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 250,
            width: Get.width,
            color: const Color(0xff365194),
          ),
          Container(
            margin: EdgeInsets.only(top: 75),
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.310,
                  color: Colors.green,
                ),
                Expanded(
                  child: Container(
                    color: Colors.purple ,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);

    var FirstControlPoint = Offset(size.width, size.height);
    var FirstPoint = Offset(size.width, size.height);

    path.quadraticBezierTo(FirstControlPoint.dx, FirstControlPoint.dy,
        FirstPoint.dx, FirstPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
