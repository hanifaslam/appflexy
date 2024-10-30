import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';

import '../../../widgets/struk_pembayaran.dart';

class PembayaranCashView extends StatefulWidget {
  @override
  _PembayaranCashViewState createState() => _PembayaranCashViewState();
}

class _PembayaranCashViewState extends State<PembayaranCashView> {
  final TextEditingController cashController = TextEditingController();
  final KasirController controller = Get.find<KasirController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Total: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(controller.total)}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff181681)),
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Text(
              'Masukkan nominal uang yang diterima:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cashController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                hintText: 'Rp 0',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final jumlahUang = double.tryParse(cashController.text) ?? 0.0;
                final totalHarga = controller.total;

                if (jumlahUang < totalHarga) {
                  Get.snackbar(
                    'Uang Tidak Cukup',
                    'Jumlah uang tidak cukup untuk membayar total',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  final kembalian = jumlahUang - totalHarga;
                  showDialog(
                    context: context,
                    builder: (context) => StrukPembayaran(
                      totalPembelian: totalHarga,
                      uangTunai: jumlahUang,
                      kembalian: kembalian,
                    ),
                  );
                }
              },
              child: Text('Proses Pembayaran',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff181681), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Adjust the radius here
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
