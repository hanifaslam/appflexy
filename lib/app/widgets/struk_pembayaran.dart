import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StrukPembayaran extends StatelessWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;

  StrukPembayaran({
    required this.totalPembelian,
    required this.uangTunai,
    required this.kembalian,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    return AlertDialog(
      title: Center(child: Text('Struk Pembayaran')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text("Detail Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildRow("Total Pembelian", currencyFormat.format(totalPembelian)),
            _buildRow("Uang Tunai", currencyFormat.format(uangTunai)),
            _buildRow("Kembalian", currencyFormat.format(kembalian)),
            Divider(),
            SizedBox(height: 10),
            Center(
                child: Text("Terima Kasih!",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Center(child: Text("Silakan berkunjung kembali")),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Tutup'),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
