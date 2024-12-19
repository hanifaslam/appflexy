import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StrukPembayaran extends StatelessWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<OrderItem> orderItems;
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

    return AlertDialog(
      title: Center(
        child: Text(
          'Struk Pembayaran',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tanggal Pesanan: $orderDate",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            Divider(thickness: 1.5),
            Text(
              "Detail Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            Center(
              child: Text(
                "Terima Kasih!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Center(
              child: Text(
                "Silakan berkunjung kembali",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.offAllNamed(Routes.DAFTAR_KASIR);
          },
          child: Text('Tutup'),
        ),
        TextButton(
          onPressed: () {
            _generatePdf(context);
          },
          child: Text('Cetak PDF'),
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
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();
    final NumberFormat currencyFormat =
    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Struk Pembayaran", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("Tanggal Pesanan: $orderDate"),
              pw.Divider(thickness: 1.5),
              pw.Text("Detail Pembayaran", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              ...orderItems.map((item) {
                return _buildPdfRow("${item.name} x${item.quantity}", currencyFormat.format(item.price * item.quantity));
              }).toList(),
              pw.Divider(thickness: 1.5),
              _buildPdfRow("Total Pembelian", currencyFormat.format(totalPembelian)),
              _buildPdfRow("Uang Tunai", currencyFormat.format(uangTunai)),
              _buildPdfRow("Kembalian", currencyFormat.format(kembalian)),
              pw.Divider(thickness: 1.5),
              pw.SizedBox(height: 10),
              pw.Center(child: pw.Text("Terima Kasih!", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Center(child: pw.Text("Silakan berkunjung kembali")),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 16)),
          pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}