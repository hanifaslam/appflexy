import 'package:apptiket/app/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/navbar.dart';
import '../../../widgets/summary_card.dart';
import '../controllers/kasir_controller.dart';


class KasirView extends GetView<KasirController> {
  const KasirView({super.key});

  @override
  Widget build(BuildContext context) {
    int _pageIndex = 1; // Indeks halaman aktif untuk KasirView

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tiket',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TicketCard(
              ticketName: 'Tiket Dewasa',
              price: 50000,
              quantity: controller.adultTicketQuantity,
              onIncrease: controller.increaseAdultTicket,
              onDecrease: controller.decreaseAdultTicket,
            ),
            const SizedBox(height: 8),
            TicketCard(
              ticketName: 'Tiket Anak',
              price: 35000,
              quantity: controller.childTicketQuantity,
              onIncrease: controller.increaseChildTicket,
              onDecrease: controller.decreaseChildTicket,
            ),
            const SizedBox(height: 16),
            SummaryCard(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Aksi pemesanan di sini
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Lakukan Pemesanan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex, // Set indeks halaman saat ini
        onTap: (index) {
          // Navigasi berdasarkan tab yang dipilih
          if (index == 0) {
            Get.offNamed(Routes.HOME); // Navigasi ke halaman HOME
          } else if (index == 1) {
            Get.offNamed(Routes.KASIR); // Navigasi ke halaman KASIR
          } else if (index == 2) {
            Get.offNamed(Routes.SETTINGS); // Navigasi ke halaman SETTINGS
          } else if (index == 3) {
            // Tab SettingsView sudah aktif, tidak melakukan apa-apa
            print('Tab SettingsView sudah aktif');
          }
        },
      ),
    );
  }
}
