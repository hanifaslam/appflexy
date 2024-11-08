import 'dart:io';
import 'package:apptiket/app/modules/pembayaran_cash/controllers/pembayaran_cash_controller.dart';
import 'package:apptiket/app/modules/pembayaran_cash/views/pembayaran_cash_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:apptiket/app/modules/sales_history/controllers/sales_history_controller.dart';

class KasirView extends StatefulWidget {
  final List<Map<String, dynamic>> pesananList;

  KasirView({required this.pesananList});

  @override
  _KasirViewState createState() => _KasirViewState();
}

class _KasirViewState extends State<KasirView> {
  final KasirController controller = Get.put(KasirController());
  final SalesHistoryController salesHistoryController = Get.put(SalesHistoryController());
  final PembayaranCashController pembayaranCashController = Get.put(PembayaranCashController());
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    print("Incoming pesananList: ${widget.pesananList}");
    print("Initialized pesananList: ${controller.pesananList}");
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Pesanan',
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Color(0xff181681)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(Routes.DAFTAR_KASIR),
        ),
      ),
      body: Obx(() {
        if (controller.pesananList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 100, color: Colors.grey),
                SizedBox(height: 16),
                Text('Tidak ada pesanan.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.pesananList.length,
                    itemBuilder: (context, index) {
                      final item = controller.pesananList[index];
                      print("Produk at index $index: $item");

                      return Obx(() {
                        final quantity = controller.localQuantities[index].value;

                        if (quantity <= 0) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.daftarKasirController.pesananList.removeAt(index);
                            controller.localQuantities.removeAt(index);
                          });
                          return const SizedBox.shrink();
                        }

                        final double hargaJual = double.tryParse(item['price'].toString()) ?? 0;
                        final String namaProduk = item['name'] ?? '';
                        final String formattedPrice = currencyFormat.format(hargaJual);

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: (item['image'] != null && File(item['image']).existsSync())
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(item['image']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon(Icons.image, size: 50),
                            title: Text(namaProduk),
                            subtitle: Text('Harga: $formattedPrice'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () => controller.updateQuantity(index, -1),
                                ),
                                Text(quantity.toString(),
                                    style: TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => controller.updateQuantity(index, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Obx(() => Text(
                        currencyFormat.format(controller.total),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text('Pilih Metode Pembayaran',
                      style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(CupertinoIcons.money_dollar, size: 50),
                          color: selectedPaymentMethod == 'cash'
                              ? Colors.green
                              : Colors.grey,
                          onPressed: () {
                            setState(() {
                              selectedPaymentMethod = 'cash';
                            });
                          },
                        ),
                        Text('Cash'),
                      ],
                    ),
                    Column(
                      children: [
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
                        ),
                        Text('QRIS'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedPaymentMethod == null) {
                        Get.snackbar(
                          'Pilih Metode Pembayaran',
                          'Silakan pilih metode pembayaran sebelum melanjutkan',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        // Save each item in sales history
                        widget.pesananList.forEach((item) {
                          salesHistoryController.addSale({
                            'name': item['name'],
                            'quantity': controller.localQuantities[widget.pesananList.indexOf(item)].value,
                            'price': item['price'],
                            'time': DateTime.now().toString(),
                            'total': controller.total,
                            'paymentMethod': selectedPaymentMethod,
                          });
                        });

                        if (selectedPaymentMethod == 'cash') {
                          Get.to(PembayaranCashView());
                        } else if (selectedPaymentMethod == 'qris') {
                          Get.snackbar(
                            'Pembayaran QRIS',
                            'Proses pembayaran QRIS berhasil',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      }
                    },
                    child: Text(
                      'Lakukan Pembayaran',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff181681),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
