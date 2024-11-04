import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sales_history_controller.dart';
import '../../pembayaran_cash/controllers/pembayaran_cash_controller.dart'; // Import PembayaranCashController
import '../../../routes/app_pages.dart'; // Import untuk route
// Import intl for currency formatting

class SalesHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Buat instance controller
    final SalesHistoryController salesController = Get.find();
    final PembayaranCashController pembayaranController =
        Get.put(PembayaranCashController());

    // Instance pembayaran controller

    // Load sales data
    salesController.loadSalesData();

    return Scaffold(
      backgroundColor: Color(0xFFFFFCF7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Get.offAllNamed(Routes.HOME), // Menghapus history saat ke home
        ),
        title: Text(
          'Riwayat Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff213F84),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Obx(() {
        // Memantau perubahan data
        return ListView.builder(
          itemCount: salesController.salesData.length,
          itemBuilder: (context, index) {
            final sale = salesController.salesData[index];
            return Card(
              color: Color(0xFFEDEDED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Color(0xFF3A6D8C)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                title: Text(
                  sale['customer'] as String? ?? 'Unknown Customer',
                  style: TextStyle(
                    color: Color(0xFF213F84),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  sale['time'] as String? ?? 'Unknown Time',
                  style: TextStyle(
                    color: Color(0xFF213F84),
                  ),
                ),
                children: [
                  Divider(color: Color(0xFF213F84)),
                  _buildSaleDetails(sale,
                      pembayaranController), // Ngambil data lewat controller
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSaleDetails(
      Map<String, dynamic> sale, PembayaranCashController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Metode Pembayaran:',
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                sale['paymentMethod'] ?? 'Unknown Method',
                style: TextStyle(color: Color(0xFF213F84)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sumber Pembayaran:',
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                sale['paymentSource'] ?? 'Unknown Source',
                style: TextStyle(color: Color(0xFF213F84)),
              ),
            ],
          ),
          SizedBox(height: 8),
          Divider(color: Color(0xFF213F84)),
          ...sale['items'].map<Widget>((item) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'Unknown Item',
                      style: TextStyle(color: Color(0xFF213F84)),
                    ),
                    Text(
                      'x${item['quantity']}',
                      style: TextStyle(color: Color(0xFF213F84)),
                    ),
                  ],
                ),
                Text(
                  'Rp ${controller.formatCurrency(item['hargaJual'] * item['quantity'])}',
                  style: TextStyle(color: Color(0xFF213F84)),
                ),
              ],
            );
          }).toList(),
          SizedBox(height: 8),
          Divider(color: Color(0xFF213F84)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp ${controller.formatCurrency(sale['total'])}',
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
