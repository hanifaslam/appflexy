import 'package:apptiket/app/modules/pembayaran_cash/views/pembayaran_cash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:apptiket/app/modules/pembayaran_cash/views/pembayaran_cash_view.dart'; // Import halaman pembayaran cash

class KasirView extends StatefulWidget {
  final List<Map<String, dynamic>> pesananList;

  KasirView({required this.pesananList});

  @override
  _KasirViewState createState() => _KasirViewState();
}

class _KasirViewState extends State<KasirView> {
  final KasirController controller = Get.put(KasirController());
  String? selectedPaymentMethod; // To store selected payment method

  @override
  void initState() {
    super.initState();

    // Initialize pesananList and ensure each product has 'quantity'
    controller.pesananList.value = widget.pesananList.map((item) {
      item['quantity'] ??= 1; // Initialize quantity to 1 if it's null
      return item;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pesanan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.pesananList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada pesanan.',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.pesananList.length,
                      itemBuilder: (context, index) {
                        final produk = controller.pesananList[index];
                        final hargaJual = produk['hargaJual'];
                        final quantity = produk['quantity'] ?? 1;

                        // Convert hargaJual to double safely
                        final hargaNum =
                            double.tryParse(hargaJual?.toString() ?? '0') ??
                                0.0;
                        final formattedPrice = currencyFormat.format(hargaNum);

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.shopping_bag, size: 40),
                            title: Text(
                                produk['namaProduk'] ?? produk['namaTiket']),
                            subtitle: Text('Harga: $formattedPrice'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    controller.updateQuantity(index, -1);
                                  },
                                ),
                                Text('$quantity'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    controller.updateQuantity(index, 1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(currencyFormat.format(controller.total),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                      child: Text('Pilih Metode Pembayaran',
                          style: TextStyle(fontSize: 16))),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(CupertinoIcons.money_dollar, size: 40),
                        color: selectedPaymentMethod == 'cash'
                            ? Colors.green
                            : Colors.grey,
                        onPressed: () {
                          setState(() {
                            selectedPaymentMethod = 'cash';
                          });
                        },
                      ), // Cash
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner, size: 40),
                        color: selectedPaymentMethod == 'qris'
                            ? Colors.green
                            : Colors.grey,
                        onPressed: () {
                          setState(() {
                            selectedPaymentMethod = 'qris';
                          });
                        },
                      ), // QRIS
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedPaymentMethod == null) {
                          // Tampilkan pesan jika metode pembayaran belum dipilih
                          Get.snackbar(
                            'Pilih Metode Pembayaran',
                            'Silakan pilih metode pembayaran sebelum melanjutkan',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else if (selectedPaymentMethod == 'cash') {
                          // Arahkan ke halaman cash payment
                          Get.to(PembayaranCashView());
                        } else if (selectedPaymentMethod == 'qris') {
                          // Lakukan pembayaran QRIS
                          // Tambahkan logika QRIS di sini
                          Get.snackbar(
                            'Pembayaran QRIS',
                            'Proses pembayaran QRIS berhasil',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text('Lakukan Pemesanan',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
