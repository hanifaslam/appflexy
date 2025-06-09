import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:apptiket/app/modules/pengaturan_profile/controllers/pengaturan_profile_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';
import 'bluetooth.dart';

class StrukPembayaranPage extends StatelessWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<OrderItem> orderItems;
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
    final res = AutoResponsive(context);
    final NumberFormat currencyFormat =
    NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

    final PengaturanProfileController profileController = Get.put(PengaturanProfileController());
    final KasirController kasirController = Get.put(KasirController());
    
    // Responsive design based on screen width
    final isTablet = res.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff181681).withOpacity(0.95),
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 0, // Remove app bar height since we're using a custom header
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff181681), Color(0xff0F0B5C).withOpacity(0.9)],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(isTablet ? 8 : 4),
              vertical: res.hp(2),
            ),
            child: Card(
              elevation: 8,
              shadowColor: Colors.black38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [                  // Success Header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: res.hp(2.5), horizontal: res.wp(4)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff181681), Color(0xff0F0B5C)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(res.wp(3)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: res.sp(isTablet ? 60 : 48),
                          ),
                        ),
                        SizedBox(height: res.hp(2)),
                        Text(
                          "Transaksi Berhasil",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: res.sp(isTablet ? 24 : 20),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Pembayaran telah diproses",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Receipt Details
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date
                          _buildRow("Tanggal", orderDate),
                          Divider(thickness: 1, color: Colors.grey.shade300, height: 32),
                          
                          // Order Items header
                          Text(
                            "Detail Pembayaran",
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff181681),
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          // Order Items list
                          ...orderItems.map((item) {
                            return _buildRow(
                              "${item.name} x${item.quantity}",
                              currencyFormat.format(item.price * item.quantity),
                            );
                          }).toList(),
                          
                          Divider(thickness: 1, color: Colors.grey.shade300, height: 32),
                          
                          // Payment Summary
                          _buildRow(
                            "Total", 
                            currencyFormat.format(totalPembelian),
                            isBold: true,
                          ),
                          if (uangTunai > 0)
                            _buildRow("Uang Tunai", currencyFormat.format(uangTunai)),
                          if (uangTunai > 0)
                            _buildRow(
                              "Kembalian", 
                              currencyFormat.format(kembalian),
                              valueColor: Colors.green.shade700,
                            ),
                            
                          Divider(thickness: 1, color: Colors.grey.shade300, height: 32),
                          
                          // Company Info
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Terima Kasih!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTablet ? 18 : 16,
                                    color: Color(0xff181681),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Obx(() => Text(
                                  profileController.companyName.value.isNotEmpty
                                      ? profileController.companyName.value
                                      : 'Nama Perusahaan Tidak Tersedia',
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                SizedBox(height: 4),
                                Obx(() => Text(
                                  profileController.companyAddress.value.isNotEmpty
                                      ? profileController.companyAddress.value
                                      : 'Alamat Tidak Tersedia',
                                  style: TextStyle(
                                    fontSize: isTablet ? 15 : 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(() => BluetoothPage(
                                totalPembelian: totalPembelian,
                                uangTunai: uangTunai,
                                kembalian: kembalian,
                                orderItems: orderItems,
                                orderDate: orderDate,
                              ));
                            },
                            icon: Icon(Icons.print, size: isTablet ? 24 : 20),
                            label: Text(
                              "Cetak",
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Color(0xff16812f),
                              foregroundColor: Colors.white,
                              elevation: 2,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.offAllNamed('/daftar-kasir');
                              kasirController.clearOrder();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                fontSize: isTablet ? 20 : 18, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Color(0xff181681),
                              foregroundColor: Colors.white,
                              elevation: 2,
                            ),
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
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Color(0xff181681) : Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? (isBold ? Color(0xff181681) : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
