import 'package:flutter/material.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

class SnkView extends StatelessWidget {
  const SnkView({super.key});

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(      appBar: AppBar(
        backgroundColor: const Color(0xff181681),
        elevation: 1,
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(22)),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(res.wp(4)),
        children: [          ListTile(
            leading: Icon(Icons.description, color: Colors.black, size: res.sp(20)),
            title: Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(1)),
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
          ListTile(            leading: Icon(Icons.description, color: Colors.black, size: res.sp(20)),
            title: Text(
              'Syarat & Ketentuan Flexy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(1)),
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
    final res = AutoResponsive(context);

    return Scaffold(      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: res.sp(22)),
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: res.sp(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: res.hp(1)),
              Text(
                content,
                style: TextStyle(
                  fontSize: res.sp(16),
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
