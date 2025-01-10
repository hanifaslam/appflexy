import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:apptiket/app/modules/pengaturan_profile/controllers/pengaturan_profile_controller.dart';
import 'bluetooth.dart';
import 'pdfpreview_page.dart' as pdf;

class StrukPembayaranPage extends StatelessWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<pdf.OrderItem> orderItems;
  final String orderDate;

  StrukPembayaranPage({
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

    final PengaturanProfileController profileController = Get.put(PengaturanProfileController());
    final KasirController kasirController = Get.put(KasirController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff181681),
          automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xff181681),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 48,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Transaksi Berhasil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow("Tanggal", orderDate),
                      Divider(thickness: 1.5),
                      Text(
                        "Detail Pembayaran",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...orderItems.map((item) {
                        return _buildRow(
                          "${item.name} x${item.quantity}",
                          currencyFormat.format(item.price * item.quantity),
                        );
                      }).toList(),
                      Divider(thickness: 1.5),
                      _buildRow("Total", currencyFormat.format(totalPembelian)),
                      if (uangTunai > 0)
                        _buildRow("Uang Tunai", currencyFormat.format(uangTunai)),
                      if (uangTunai > 0)
                        _buildRow("Kembalian", currencyFormat.format(kembalian)),
                      Divider(thickness: 1.5),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Terima Kasih!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Obx(() => Text(
                              profileController.companyName.value.isNotEmpty
                                  ? profileController.companyName.value
                                  : 'Nama Perusahaan Tidak Tersedia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Obx(() => Text(
                              profileController.companyAddress.value.isNotEmpty
                                  ? profileController.companyAddress.value
                                  : 'Alamat Tidak Tersedia',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1.5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
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
                        icon: Icon(Icons.description),
                        label: Text(
                          "Simpan Sebagai PDF",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 53),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          backgroundColor: Color(0xff181681),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16,),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => BluetoothPage(
                            totalPembelian: totalPembelian,
                            uangTunai: uangTunai,
                            kembalian: kembalian,
                            orderItems: orderItems,
                            orderDate: orderDate,
                          ));
                        },
                        icon: Icon(Icons.print, size: 20), // Ikon printer
                        label: Text(
                          "Cetak",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 55.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Color(0xff16812f),
                          foregroundColor: Colors.white,
                        ),
                      ),

                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Get.offAllNamed('/daftar-kasir');
                          kasirController.clearOrder();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 80.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                          backgroundColor: Color(0xff16812f),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16,
                fontWeight: label == "Total" ? FontWeight.bold : FontWeight.normal),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
