import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:get/get.dart';
import '../modules/pengaturan_profile/controllers/pengaturan_profile_controller.dart';

class PDFPreviewPage extends StatelessWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<OrderItem> orderItems;
  final String orderDate;

  PDFPreviewPage({
    required this.totalPembelian,
    required this.uangTunai,
    required this.kembalian,
    required this.orderItems,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Struk'),
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final NumberFormat currencyFormat =
    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    // Ambil data perusahaan dari ProfileController
    final PengaturanProfileController profileController = Get.put(PengaturanProfileController());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
        build: (context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Nama dan alamat perusahaan
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        profileController.companyName.value.isNotEmpty
                            ? profileController.companyName.value
                            : 'Nama Perusahaan Tidak Tersedia',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        profileController.companyAddress.value.isNotEmpty
                            ? profileController.companyAddress.value
                            : 'Alamat Tidak Tersedia',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Text(
                    "Tanggal: $orderDate",
                    style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
                pw.Divider(thickness: 1),
                pw.Text(
                  "Detail Pembelian",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                ...orderItems.map((item) {
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("${item.name} x${item.quantity}",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text(
                          currencyFormat.format(item.price * item.quantity),
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),
                _buildPdfRow(
                    "Total Pembelian", currencyFormat.format(totalPembelian)),
                if (uangTunai > 0)
                  _buildPdfRow("Uang Tunai", currencyFormat.format(uangTunai)),
                if (uangTunai > 0)
                  _buildPdfRow("Kembalian", currencyFormat.format(kembalian)),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    "Terima Kasih!",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildPdfRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 12)),
        pw.Text(value,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
