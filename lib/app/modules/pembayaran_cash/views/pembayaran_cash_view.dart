import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/struk_pembayaran.dart';
import '../controllers/pembayaran_cash_controller.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';

class PembayaranCashView extends StatefulWidget {
  @override
  _PembayaranCashViewState createState() => _PembayaranCashViewState();
}

class _PembayaranCashViewState extends State<PembayaranCashView> {
  final TextEditingController cashController = TextEditingController();
  final PembayaranCashController pembayaranController =
      Get.put(PembayaranCashController());
  final KasirController kasirController =
      Get.find<KasirController>(); // Renamed for clarity

  // Currency formatter
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    cashController.text = currencyFormat.format(0);
  }

  void _onCashInputChanged(String value) {
    String formattedValue;
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isNotEmpty) {
      double parsedValue = double.parse(value);
      formattedValue = currencyFormat.format(parsedValue);
    } else {
      formattedValue = currencyFormat.format(0);
    }
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
              'Total: ${currencyFormat.format(kasirController.total)}', // Use total from KasirController
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
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: pembayaranController.pesananList.length,
                  itemBuilder: (context, index) {
                    final item = pembayaranController.pesananList[index];
                    return ListTile(
                      title: Text(item['nama']),
                      subtitle: Text(
                          '${currencyFormat.format(item['hargaJual'])} x ${item['quantity']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                pembayaranController.updateQuantity(index, -1),
                          ),
                          Text('${item['quantity']}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                pembayaranController.updateQuantity(index, 1),
                          ),
                        ],
                      ),
                    );
                  },
                )),
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
                final jumlahUang = double.tryParse(cashController.text
                        .replaceAll(RegExp(r'[^0-9]'), '')) ??
                    0.0;
                final totalHarga =
                    kasirController.total; // Use total from KasirController

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
                backgroundColor: const Color(0xff181681),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
