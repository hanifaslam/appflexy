import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex; // Indeks halaman aktif
  final ValueChanged<int> onTap; // Callback saat tab ditekan

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF5F5DD), // Warna latar navbar
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.1), // Warna dan transparansi shadow
            spreadRadius: 2, // Sebar bayangan
            blurRadius: 8, // Blur bayangan
            offset: const Offset(0, -3), // Arah bayangan (x, y)
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex.clamp(0, 2), // Validasi indeks
        onTap: onTap, // Panggil callback saat tab ditekan
        backgroundColor: Colors.white, // Warna latar navbar
        selectedItemColor: Colors.black, // Warna item aktif
        unselectedItemColor: Colors.grey, // Warna item tidak aktif
        showSelectedLabels: false, // Sembunyikan label item terpilih
        showUnselectedLabels: false, // Sembunyikan label item tidak terpilih
        type:
            BottomNavigationBarType.fixed, // Untuk memastikan semua item tampil
        items: [
          BottomNavigationBarItem(
            icon:
                _buildNavItem(Icons.home_outlined, 0),
            activeIcon: _buildNavItem(Icons.home, 0), // Ikon untuk tab pertama
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(
                CupertinoIcons.arrow_right_arrow_left, 1), // Tab kedua
            label: 'Kasir',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(CupertinoIcons.person, 2),
            activeIcon: _buildNavItem(CupertinoIcons.person_solid, 2), // Tab ketiga
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun item navbar dengan lingkaran dan ikon
  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = currentIndex == index; // Cek apakah ikon terpilih

    
    return Container(
      width: 30, // Lebar kontainer (ukuran lingkaran)
      height: 30, // Tinggi kontainer (ukuran lingkaran)
      
      child: Center(
        child: Icon(
          icon,
          color: isSelected
              ? Colors.black
              : Colors.grey, // Ubah warna berdasarkan status
          size: 30, // Ukuran ikon
        ),
      ),
    );
  }
}
