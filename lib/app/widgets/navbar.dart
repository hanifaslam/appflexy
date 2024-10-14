import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class CustomNavigationBar extends StatelessWidget {
  final int currentIndex; // Indeks halaman saat ini
  final Function(int) onTap; // Callback untuk saat tab ditekan

  CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.white, // Latar belakang navbar
      color: const Color(0xffF5F5DD), // Warna navbar
      height: 70, // Tinggi navbar
      animationDuration: const Duration(milliseconds: 300), // Durasi animasi
      onTap: (index) {
        print('Tab index: $index'); // Log saat tab ditekan
        onTap(index); // Panggil callback yang diteruskan
      },
      items: [
        _buildNavBarItem(Icons.home_outlined), // Item navbar tanpa teks
        _buildNavBarItem(CupertinoIcons.arrow_right_arrow_left),
        _buildNavBarItem(Icons.person_2_outlined),
      ],
    );
  }

  // Widget untuk item navbar tanpa teks di bawah ikon
  Widget _buildNavBarItem(IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 25, // Ukuran lingkaran
          backgroundColor: const Color(0xffF5F5DD),
          child: Icon(icon, color: Colors.black, size: 40),
        ),
      ],
    );
  }
}
