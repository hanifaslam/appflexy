import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sales_history_controller.dart';
import '../../../routes/app_pages.dart'; // Import untuk route

class SalesHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Buat instance controller
    final SalesHistoryController controller = Get.find();

    return Scaffold(
      backgroundColor: Color(0xFFFFFCF7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Get.offAllNamed(Routes.HOME), // Menghapus history saat ke home
        ),
        title: Text(
          'Riwayat Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFF5F5F5),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Obx(() {
        // Memantau perubahan data
        return ListView.builder(
          itemCount: controller.salesData.length,
          itemBuilder: (context, index) {
            final sale = controller.salesData[index];
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
                  _buildSaleDetails(
                      sale, controller), // Ngambil data lewat controller
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSaleDetails(
      Map<String, dynamic> sale, SalesHistoryController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (sale['paymentMethod'] == 'QRIS')
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Text(
                      'QRIS',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Widget ganti gambar QR Code (optional, jadikan ini komentar dulu)
              // Image.network(
              //   'https://link-ke-gambar-qr-code',
              //   width: 50,
              //   height: 50,
              // ),

              if (sale['paymentMethod'] == 'Tunai')
                Icon(Icons.attach_money, color: Colors.grey),
              if (sale['paymentMethod'] == 'Debit')
                Icon(Icons.credit_card, color: Colors.grey),

              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale['paymentSource'],
                    style: TextStyle(
                      color: Color(0xFF213F84),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sale['paymentMethod'],
                    style: TextStyle(
                      color: Color(0xFF213F84),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 8),
          ...sale['items'].map<Widget>((item) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(color: Color(0xFF213F84)),
                    ),
                    Text(
                      'x${item['quantity']}',
                      style: TextStyle(color: Color(0xFF213F84)),
                    ),
                  ],
                ),
                Text(
                  'Rp ${controller.formatCurrency(item['quantity'] * item['price'])}',
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
