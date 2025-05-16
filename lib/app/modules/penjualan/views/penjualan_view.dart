// MENAMBAHKAN TIKET (JUMLAH TIKET / JENIS TIKET)

import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class PenjualanView extends StatefulWidget {
  const PenjualanView({super.key});

  @override
  State<PenjualanView> createState() => _PenjualanViewState();
}

class _PenjualanViewState extends State<PenjualanView> {
  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiket Anda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Pindah ke halaman profil ketika tombol kembali ditekan
            Get.offAllNamed(Routes.HOME);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Column(
          children: [
            TicketCard(res: res),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Menempatkan di kanan
        children: [
          Padding(
            padding: EdgeInsets.all(res.wp(2)),
            child: FloatingActionButton(
              onPressed: () {
                // Aksi ketika tombol tambah ditekan
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final AutoResponsive res;
  const TicketCard({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigasi ke halaman kasir (ubah sesuai kebutuhan)
        // Get.to(() => KasirView(pesananList: []));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(res.wp(3)),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tiket Dewasa',
                    style: TextStyle(
                      fontSize: res.sp(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: res.hp(0.5)),
                  Text(
                    'Untuk usia 15 ke atas',
                    style: TextStyle(
                      fontSize: res.sp(14),
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: res.hp(1)),
                  Text(
                    '50.000',
                    style: TextStyle(
                      fontSize: res.sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                ),
                onPressed: () {
                  // Aksi ketika tombol menu ditekan
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
