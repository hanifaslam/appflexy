import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../modules/profile/controllers/profile_controller.dart';
import 'pdfpreview_page.dart' as pdf;

class StrukPembayaran extends StatelessWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<pdf.OrderItem> orderItems;
  final String orderDate;

  StrukPembayaran({
    required this.totalPembelian,
    required this.uangTunai,
    required this.kembalian,
    required this.orderItems,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    final ProfileController profileController = Get.put(ProfileController());

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    profileController.companyName.value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    profileController.companyAddress.value,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Divider(thickness: 1.5),
            Text(
              "Tanggal Pesanan: $orderDate",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            Divider(thickness: 1.5),
            Text(
              "Detail Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...orderItems.map((item) {
              return _buildRow(
                "${item.name} x${item.quantity}",
                currencyFormat.format(item.price * item.quantity),
              );
            }).toList(),
            Divider(thickness: 1.5),
            _buildRow("Total Pembelian", currencyFormat.format(totalPembelian)),
            _buildRow("Uang Tunai", currencyFormat.format(uangTunai)),
            _buildRow("Kembalian", currencyFormat.format(kembalian)),
            Divider(thickness: 1.5),
            Center(
              child: Text(
                "Terima Kasih!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.offAllNamed('/daftar-kasir');
          },
          child: Text('Tutup'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Get.to(() => pdf.PDFPreviewPage(
                  totalPembelian: totalPembelian,
                  uangTunai: uangTunai,
                  kembalian: kembalian,
                  orderItems: orderItems,
                  orderDate: orderDate,
                ));
          },
          icon: Icon(Icons.picture_as_pdf),
          label: Text('PDF'),
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
