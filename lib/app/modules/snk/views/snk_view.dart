import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syarat & Ketentuan',
      theme: ThemeData(
        primaryColor: const Color(0xff181681),
      ),
      home: const SnkView(),
    );
  }
}

class SnkView extends StatelessWidget {
  const SnkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff181681),
        elevation: 1,
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.description, color: Colors.black),
            title: const Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailPage(
                    title: 'Kebijakan Privasi',
                    content: 'Flexy mengumpulkan informasi pribadi seperti nama, email, dan data transaksi untuk mengelola akun, memproses tiket, serta meningkatkan layanan. Data Anda dilindungi dengan teknologi keamanan dan tidak akan dibagikan tanpa izin kecuali untuk kepentingan hukum atau layanan pihak ketiga. Anda dapat mengakses, memperbarui, atau menghapus data pribadi Anda dengan menghubungi kami di support@flexy.com',
                  ),
                ),
              );
            },
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          ListTile(
            leading: const Icon(Icons.description, color: Colors.black),
            title: const Text(
              'Syarat & Ketentuan Flexy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailPage(
                      title: 'Syarat & Ketentuan Flexy',
                      content: 'Dengan menggunakan Flexy, Anda setuju untuk menggunakan aplikasi sesuai hukum, menjaga keamanan akun, dan tidak melakukan aktivitas yang merugikan atau ilegal. Flexy tidak bertanggung jawab atas kerugian akibat penggunaan aplikasi atau gangguan teknis. Semua konten aplikasi dilindungi oleh hak kekayaan intelektual, dan pelanggaran terhadap ketentuan dapat mengakibatkan penghapusan akun. Kami berhak mengubah atau menghentikan layanan kapan saja dengan pemberitahuan.'),
                ),
              );
            },
          ),
          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String content;

  const DetailPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
