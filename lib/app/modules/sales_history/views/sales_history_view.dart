import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sales_history_controller.dart';
import '../../../routes/app_pages.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class SalesHistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SalesHistoryController salesController =
        Get.find<SalesHistoryController>();
    final res = AutoResponsive(context);

    return Scaffold(
      backgroundColor: Color(0xFFFFFCF7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(20)),
          onPressed: () => Get.offAllNamed(Routes.HOME),
        ),
        title: Text(
          'Riwayat Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: res.sp(18),
          ),
        ),
        backgroundColor: Color(0xff181681),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          Obx(() {
            return DropdownButton<String>(
              value: salesController.filterType.value,
              icon: Icon(Icons.more_vert, color: Colors.white, size: res.sp(20)),
              dropdownColor: Color(0xff181681),
              items: <String>['Semua', 'Mingguan', 'Bulanan', 'Tahunan']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white, fontSize: res.sp(14))),
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
          return Center(
            child: Text(
              'Belum ada riwayat penjualan.',
              style: TextStyle(fontSize: res.sp(16)),
            ),
          );
        }
        return ListView.builder(
          itemCount: salesController.filteredSalesHistory.length,
          itemBuilder: (context, index) {
            final sale = salesController.filteredSalesHistory[index];
            return Card(
              color: Color(0xFFEDEDED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(res.wp(2)),
                side: BorderSide(color: Color(0xFF3A6D8C)),
              ),
              margin: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(1)),
              child: ExpansionTile(
                title: Text(
                  sale['customer'] ?? 'Unknown Customer',
                  style: TextStyle(
                    color: Color(0xFF213F84),
                    fontWeight: FontWeight.bold,
                    fontSize: res.sp(15),
                  ),
                ),
                subtitle: Text(
                  sale['time'] ?? 'Unknown Time',
                  style: TextStyle(
                    color: Color(0xFF213F84),
                    fontSize: res.sp(13),
                  ),
                ),
                children: [
                  Divider(color: Color(0xFF213F84)),
                  _buildSaleDetails(sale, salesController, res),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSaleDetails(
      Map<String, dynamic> sale, SalesHistoryController salesController, AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(1)),
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
                  fontSize: res.sp(14),
                ),
              ),
              Text(
                sale['payment_method'] ?? 'Unknown Method',
                style: TextStyle(color: Color(0xFF213F84), fontSize: res.sp(14)),
              ),
            ],
          ),
          SizedBox(height: res.hp(1)),
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
                      style: TextStyle(color: Color(0xFF213F84), fontSize: res.sp(13)),
                    ),
                    Text(
                      'x${item['quantity']}',
                      style: TextStyle(color: Color(0xFF213F84), fontSize: res.sp(12)),
                    ),
                  ],
                ),
                Text(
                  salesController.formatCurrency(item['total_item_price']),
                  style: TextStyle(color: Color(0xFF213F84), fontSize: res.sp(13)),
                ),
              ],
            );
          }).toList(),
          SizedBox(height: res.hp(1)),
          Divider(color: Color(0xFF213F84)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                  fontSize: res.sp(15),
                ),
              ),
              Text(
                salesController.formatCurrency(sale['total']),
                style: TextStyle(
                  color: Color(0xFF213F84),
                  fontWeight: FontWeight.bold,
                  fontSize: res.sp(15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
