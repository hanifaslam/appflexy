// ignore_for_file: avoid_print

import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// HomeView dengan CurvedNavigationBar
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _pageIndex = 0; // Index untuk melacak halaman aktif

  // Daftar halaman untuk setiap tab
  final List<Widget> _pages = [
    const Center(child: Text('Beranda', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Penjualan', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Settings', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181681),
      appBar: _buildAppBar(), // AppBar dengan gaya kustom
      body: Stack(
        children: [
          _buildBackground(), // Latar belakang putih
          _buildContent(), // Konten utama di atas latar
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index; // Update halaman aktif

            // Navigasi ke halaman yang sesuai
            if (index == 0) {
              Get.offAllNamed(
                  Routes.HOME); // Ganti dengan nama rute yang sesuai
            } else if (index == 1) {
              Get.offAllNamed(
                  Routes.DAFTAR_KASIR); // Ganti dengan nama rute yang sesuai
            } else if (index == 2) {
              Get.offAllNamed(
                  Routes.PROFILEUSER2); // Ganti dengan nama rute yang sesuai
            }
          });
        },
      ),
    );
  }

  // AppBar dengan judul dan style kustom
  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 150, // Tinggi AppBar
      backgroundColor: const Color(0xff181681), // Warna latar AppBar
      elevation: 0, // Hilangkan bayangan
      title: Container(
        padding: const EdgeInsets.only(top: 5.0), // Padding atas kecil
        child: const Text(
          "Flexy",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 50, // Ukuran font besar
            fontWeight: FontWeight.normal,
            color: Color(0xffffffff), // Warna biru
          ),
        ),
      ),
    );
  }

  // Latar belakang putih untuk halaman
  Widget _buildBackground() {
    return Container(
      height: Get.height, // Isi layar penuh secara vertikal
      width: Get.width, // Isi layar penuh secara horizontal
      color: Color(0xff181681), // Warna putih
    );
  }

  // Konten utama dengan informasi dan bagian bawah
  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: 10), // Margin atas
      child: Column(
        children: [
          _buildUserInfoSection(), // Bagian informasi pengguna
          const SizedBox(height: 20), // Jarak antar konten
          _buildBottomSection(), // Bagian bawah dengan ikon besar
        ],
      ),
    );
  }

  // Bagian informasi pengguna dengan avatar dan notifikasi
  Widget _buildUserInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25), // Margin kiri-kanan
      decoration: BoxDecoration(
        color: const Color(0xff365194).withOpacity(1), // Warna biru tua
        borderRadius: BorderRadius.circular(20), // Sudut melengkung
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Padding dalam kontainer
        child: Column(
          children: [
            Row(
              children: [
                // Avatar pengguna dengan gambar dari asset
                const CircleAvatar(
                  radius: 35, // Ukuran avatar
                  backgroundImage: AssetImage('assets/logo/logoflex.png'),
                ),
                const SizedBox(width: 10), // Jarak antar avatar dan teks
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "AmbatuJawir", // Nama pengguna
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Farhan Kebab", // Deskripsi pengguna
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(), // Ruang kosong untuk push ikon notifikasi
                const Padding(
                  padding: EdgeInsets.only(right: 20.0), // Margin kanan ikon
                  child: Icon(
                    Icons.notifications, // Ikon notifikasi
                    color: Colors.white,
                    size: 40, // Ukuran ikon
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Jarak elemen

            // Kontainer putih dengan ikon di dalamnya
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Color(0xffffffff), // Latar putih
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularIconButton(
                    Icons.confirmation_num_outlined,
                    'Data', // Menggunakan Inter font
                    'Tiket',
                    const Color(0xffFFAF00),
                    Colors.white,
                    onTap: () {
                      Get.offAllNamed(Routes.MANAJEMEN_TIKET);
                    },
                  ),
                  _buildCircularIconButton(
                    Icons.bar_chart,
                    'Riwayat', // Menggunakan Inter font
                    'Penjualan',
                    const Color(0xff5475F9),
                    Colors.white,
                    onTap: () {
                      Get.offAllNamed(Routes
                          .SALES_HISTORY); // sementara masih manggil pages yg sama
                    },
                  ),
                  _buildCircularIconButton(
                    CupertinoIcons.cube_box,
                    'Data',
                    'Barang', // Menggunakan Inter font
                    const Color(0xffF95454),
                    Colors.white,
                    onTap: () {
                      Get.toNamed(Routes
                          .DAFTAR_PRODUK); // sementara masih manggil pages yg sama
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bagian bawah dengan latar putih dan ikon besar
  Widget _buildBottomSection() {
    return Expanded(
      child: Container(
        width: double.infinity, // Lebar penuh
        decoration: const BoxDecoration(
          color: Colors.white, // Latar belakang putih
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(37), // Sudut atas kiri melengkung
            topRight: Radius.circular(37), // Sudut atas kanan melengkung
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Bayangan
              offset: Offset(0, 4), // Posisi bayangan
              blurRadius: 20, // Blur radius bayangan
              spreadRadius: 3, // Luas bayangan
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Rata tengah
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Icon(
                CupertinoIcons.cube_box, // Ikon besar
                size: 150,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10), // Jarak dengan teks
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                'Tidak ada daftar produk yang dapat ditampilkan. Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.',
                textAlign: TextAlign.center, // Rata tengah
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol dengan ikon lingkaran
  Widget _buildCircularIconButton(
    IconData icon,
    String label1,
    String label2,
    Color circleColor,
    Color iconColor, {
    VoidCallback? onTap, // Parameter opsional untuk fungsi onTap
  }) {
    return GestureDetector(
      onTap: onTap, // Menangani event klik
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ukuran minimum kolom
        children: [
          Container(
            width: 70, // Lebar kontainer
            height: 70, // Tinggi kontainer
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Bentuk lingkaran
              color: circleColor, // Warna latar
            ),
            padding: const EdgeInsets.all(10.0), // Padding dalam
            child: Icon(
              icon, // Ikon yang diterima
              size: 35,
              color: iconColor, // Warna ikon
            ),
          ),
          const SizedBox(height: 4), // Jarak dengan teks
          Column(
            children: [
              Text(
                label1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter', // Menggunakan Inter font
                  fontStyle: FontStyle.normal, // Menggunakan normal style
                ),
              ),
              Text(
                label2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter', // Menggunakan Inter font
                  fontStyle: FontStyle.normal, // Menggunakan normal style
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
