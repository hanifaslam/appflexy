import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/pdfpreview_page.dart';
import '../../../widgets/struk_pembayaran.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';

class PembayaranCashView extends StatefulWidget {
  @override
  _PembayaranCashViewState createState() => _PembayaranCashViewState();
}

class _PembayaranCashViewState extends State<PembayaranCashView> {
  final TextEditingController cashController = TextEditingController();
  final PembayaranCashController pembayaranController =
      Get.put(PembayaranCashController());
  final KasirController kasirController = Get.find<KasirController>();
  final SalesHistoryController salesHistoryController =
      Get.find<SalesHistoryController>();

  // Currency formatter
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  // Variable untuk melacak nominal yang sedang dipilih
  int? selectedNominal;

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

  Widget _buildNominalButton(int nominal, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedNominal = nominal;
        });
        cashController.text = currencyFormat.format(nominal.toDouble());
      },
      child: Text(
        currencyFormat.format(nominal),
        style: TextStyle(
          fontWeight: selectedNominal == nominal ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Total: ${currencyFormat.format(kasirController.total)}',
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
                          '${currencyFormat.format(item['price'])} x ${item['quantity']}'),
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

                border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                hintText: 'Rp 0',
              ),
              onChanged: _onCashInputChanged,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNominalButton(20000, Colors.green.shade100),
                _buildNominalButton(50000, Colors.blue.shade100),
                _buildNominalButton(100000, Colors.red.shade100),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNominalButton(150000, Colors.purple.shade100),
                _buildNominalButton(200000, Colors.yellow.shade100),
                _buildNominalButton(250000, Colors.orange.shade100),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final jumlahUang = double.tryParse(cashController.text
                        .replaceAll(RegExp(r'[^0-9]'), '')) ??

                    0.0;
                final totalHarga = kasirController.total;

                if (jumlahUang < totalHarga) {
                  Get.snackbar(
                    'Pembayaran Gagal',
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
                      orderItems: kasirController.pesananList.map((item) {
                        final index =
                        kasirController.pesananList.indexOf(item);
                        return OrderItem(
                          name: item['name'],
                          quantity: kasirController.localQuantities[index].value,
                          price: item['price'],
                        );
                      }).toList(),
                      orderDate:
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    ),
                  );

                  Get.snackbar(
                    'Pembayaran Berhasil',
                    'Pembayaran berhasil diproses. Kembalian: ${currencyFormat.format(kembalian)}',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  kasirController.clearOrder();
                  Get.back();
                }
              },
              child: Text('Proses Pembayaran', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff181681),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
