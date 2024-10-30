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

  // Formatter for currency
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Set initial formatted value if needed
    cashController.text = currencyFormat.format(0);
  }

  void _onCashInputChanged(String value) {
    String formattedValue;

    // Remove any non-numeric characters
    value = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the numeric value
    if (value.isNotEmpty) {
      double parsedValue = double.parse(value);
      formattedValue = currencyFormat.format(parsedValue);
    } else {
      formattedValue = currencyFormat.format(0);
    }

    // Update the controller text with formatted value
    cashController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Total: ${currencyFormat.format(controller.total)}',
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
              onChanged: _onCashInputChanged,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Parse the unformatted numeric value
                final jumlahUang = double.tryParse(cashController.text
                        .replaceAll(RegExp(r'[^0-9]'), '')) ??
                    0.0;
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
