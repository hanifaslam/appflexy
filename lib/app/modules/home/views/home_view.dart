import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

// Widget utama untuk tampilan Home
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), // Membuat AppBar
      body: Stack(
        children: [
          _buildBackground(), // Latar belakang berwarna abu-abu
          _buildContent(), // Konten utama di atas latar belakang
        ],
      ),
    );
  }

  // Fungsi untuk membangun AppBar dengan judul dan gaya khusus
  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 150, // Ubah tinggi AppBar menjadi lebih kecil
      backgroundColor: const Color(0xffffffff), // Warna latar belakang AppBar
      elevation: 0, // Menghilangkan bayangan AppBar
      title: Container(
        padding:
            const EdgeInsets.only(top: 5.0), // Atur padding atas lebih sedikit
        child: const Text(
          "Flexy", // Judul aplikasi
          style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 50, // Ukuran font lebih kecil
              fontWeight: FontWeight.normal,
              color: Color(0xff365194) // Ketebalan font
              ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun latar belakang berwarna abu-abu
  Widget _buildBackground() {
    return Container(
      height: Get.height, // Mengisi tinggi layar penuh
      width: Get.width, // Mengisi lebar layar penuh
      color: Color(0xffffffff), // Warna latar belakang abu-abu
    );
  }

  // Fungsi untuk membangun konten utama aplikasi
  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: 10), // Memberikan margin atas
      child: Column(
        children: [
          _buildUserInfoSection(), // Bagian informasi pengguna
          const SizedBox(height: 20), // Jarak antar konten
          _buildBottomSection(), // Bagian bawah dengan latar ungu
        ],
      ),
    );
  }

  // Fungsi untuk membuat bagian informasi pengguna
  Widget _buildUserInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25), // Margin kiri & kanan
      decoration: BoxDecoration(
        color: const Color(0xff365194), // Warna biru tua
        borderRadius: BorderRadius.circular(20), // Sudut melengkung
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(20.0), // Mengurangi padding di dalam kontainer
        child: Column(
          children: [
            Row(
              children: [
                // Avatar pengguna
                const CircleAvatar(
                  radius: 35, // Ukuran radius avatar
                  backgroundImage: NetworkImage(
                    'https://example.com/profile-pic.png', // URL foto profil
                  ),
                ),
                const SizedBox(width: 10), // Jarak antara avatar dan teks
                // Nama dan deskripsi pengguna
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "AmbatuJawir", // Nama pengguna
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Farhan Kebab", // Deskripsi pengguna
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const Spacer(), // Ruang kosong untuk mendorong ikon ke kanan
                // Ikon notifikasi
                const Padding(
                  padding:
                      EdgeInsets.only(right: 20.0), // Jarak dari tepi kanan
                  child: Icon(
                    Icons.notifications, // Ikon notifikasi
                    color: Colors.white,
                    size: 40, // Ukuran ikon
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Jarak antar konten

            // Kontainer putih untuk ikon
            Container(
              margin: const EdgeInsets.only(
                  top: 10), // Margin atas untuk kontainer putih
              decoration: BoxDecoration(
                color: const Color(
                    0xffffffff), // Warna latar belakang menjadi putih
                borderRadius:
                    BorderRadius.all(Radius.circular(20)), // Radius sudut
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 15), // Padding vertikal
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Menggunakan spaceEvenly untuk mendistribusikan ikon secara merata
                children: [
                  _buildCircularIconButton(Icons.confirmation_num_outlined,
                      'Data', 'Tiket', Color(0xffD8F4FC), Color(0xff64B3CA)),
                  _buildCircularIconButton(Icons.bar_chart, 'Riwayat',
                      'Penjualan', Color(0xffA8B4D1), Color(0xff213F84)),
                  _buildCircularIconButton(CupertinoIcons.cube_box, 'Data',
                      'Barang', Color(0xffE2F7FD), Color(0xff96C0CC)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat bagian bawah dengan latar putih
  Widget _buildBottomSection() {
    return Expanded(
      child: Container(
        width:
            double.infinity, // Mengatur lebar kontainer mengikuti lebar layar
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang putih
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(37), // Sudut atas kiri melengkung
            topRight: Radius.circular(37), // Sudut atas kanan melengkung
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Warna bayangan
              offset: Offset(0, 4), // Mengatur posisi bayangan (x, y)
              blurRadius: 20, // Mengatur seberapa kabur bayangan
              spreadRadius: 3, // Mengatur seberapa luas bayangan
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Menempatkan konten di tengah secara horizontal
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  top: 25.0), // Menambahkan padding atas pada ikon
              child: Icon(
                CupertinoIcons.cube_box, // Ikon yang digunakan
                size: 150, // Ukuran ikon
                color: Colors.grey, // Warna ikon
              ),
            ),
            const SizedBox(height: 10), // Jarak antara ikon dan teks
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 50.0), // Menambahkan padding horizontal pada teks
              child: Text(
                'Tidak ada daftar produk yang dapat ditampilkan. Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.', // Teks yang ditampilkan di bawah ikon
                style: TextStyle(
                  fontSize: 18, // Ukuran font
                  color: Colors.grey, // Warna teks
                  fontWeight: FontWeight.normal, // Ketebalan font
                ),
                textAlign: TextAlign.center, // Rata tengah
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun tombol menu dengan ikon lingkaran
  Widget _buildCircularIconButton(IconData icon, String label1, String label2,
      Color circleColor, Color iconColor) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ukuran minimum untuk kolom
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Membuat bentuk lingkaran
            color: circleColor, // Warna latar belakang lingkaran
          ),
          padding: const EdgeInsets.all(10.0), // Padding di dalam lingkaran
          child: Icon(
            icon, // Menggunakan ikon yang diterima
            size: 35, // Ukuran ikon
            color: iconColor, // Warna ikon
          ),
        ),
        const SizedBox(height: 4), // Jarak antara ikon dan label (lebih dekat)
        Column(
          children: [
            Text(
              label1, // Label baris pertama
              style: const TextStyle(
                color: Colors.black, // Warna teks
                fontWeight: FontWeight.bold, // Ketebalan teks
              ),
            ),
            Text(
              label2, // Label baris kedua
              style: const TextStyle(
                color: Colors.black, // Warna teks
                fontWeight: FontWeight.bold, // Ketebalan teks
              ),
            ),
          ],
        ),
      ],
    );
  }
}
