import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sales_history_controller.dart';
import '../../../routes/app_pages.dart';

class SalesHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SalesHistoryController salesController = Get.find<SalesHistoryController>();

    return Scaffold(
      backgroundColor: Color(0xFFFFFCF7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed(Routes.HOME),
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
        actions: [
          Obx(() {
            return DropdownButton<String>(
              value: salesController.filterType.value,
              icon: Icon(Icons.more_vert, color: Colors.white), // Change to three dots icon
              dropdownColor: Color(0xff213F84),
              items: <String>['All', 'Weekly', 'Monthly', 'Yearly'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  salesController.setFilter(newValue);
                }
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (salesController.filteredSalesHistory.isEmpty) {
          return Center(child: Text('Belum ada riwayat penjualan.'));
        }
        return ListView.builder(
          itemCount: salesController.filteredSalesHistory.length,
          itemBuilder: (context, index) {
            final sale = salesController.filteredSalesHistory[index];
            return Card(
              color: Color(0xFFEDEDED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Color(0xFF3A6D8C)),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                title: Text(
                  sale['customer'] ?? 'Unknown Customer',
                  style: TextStyle(
                    color: Color(0xFF213F84),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  sale['time'] ?? 'Unknown Time',
                  style: TextStyle(
                    color: Color(0xFF213F84),
                  ),
                ),
                children: [
                  Divider(color: Color(0xFF213F84)),
                  _buildSaleDetails(sale, salesController),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSaleDetails(Map<String, dynamic> sale, SalesHistoryController salesController) {
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
                sale['payment_method'] ?? 'Unknown Method',
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
                  salesController.formatCurrency(item['total_item_price']),
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
                salesController.formatCurrency(sale['total']),
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}