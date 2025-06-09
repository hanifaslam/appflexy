import 'dart:io';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // Add responsive import

import '../../../widgets/struk_pembayaran.dart';

class QrisPaymentView extends StatelessWidget {
  final KasirController kasirController = Get.put(KasirController());

  // Modern color palette
  static const Color primaryBlue = Color(0xff181681);
  static const Color lightBlue = Color(0xFFE8E9FF);
  static const Color darkBlue = Color(0xff0F0B5C);
  static const Color accentBlue = Color(0xff2A23A3);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  // Fungsi untuk mengambil path gambar QR Code yang tersimpan di SharedPreferences
  Future<File?> getQrCodeImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath =
        prefs.getString('qrCodePath'); // Ambil path gambar yang disimpan
    if (savedPath != null) {
      final file = File(savedPath);
      if (await file.exists()) {
        return file; // Kembalikan file jika ada
      }
    }
    return null; // Jika tidak ada, kembalikan null
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildModernAppBar(res),
      body: FutureBuilder<File?>(
        future: getQrCodeImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState(res);
          }
          if (snapshot.hasData && snapshot.data != null) {
            return _buildQRCodeContent(context, snapshot.data!, res);
          } else {
            return _buildEmptyState(res);
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(AutoResponsive res) {
    return PreferredSize(
      preferredSize: Size.fromHeight(res.hp(9)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryBlue, darkBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: res.wp(2.5),
              offset: Offset(0, res.hp(0.5)),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(0.5), res.wp(5), res.hp(1.5)),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(22)),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () => Get.back(),
                ),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'QRIS Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: res.sp(18),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Scan untuk pembayaran',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: res.sp(13),
                          fontWeight: FontWeight.w400,
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

  Widget _buildLoadingState(AutoResponsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: res.wp(16),
            height: res.wp(16),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(res.wp(8)),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: primaryBlue,
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: res.hp(3)),
          Text(
            'Memuat QR Code...',
            style: TextStyle(
              color: textSecondary,
              fontSize: res.sp(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeContent(BuildContext context, File qrFile, AutoResponsive res) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(res.wp(5)),
      child: Column(
        children: [
          SizedBox(height: res.hp(2)),
          
          // Payment amount card
          _buildPaymentAmountCard(res),
          
          SizedBox(height: res.hp(4)),
          
          // QR Code container
          _buildQRCodeContainer(qrFile, res),
          
          SizedBox(height: res.hp(4)),
          
          // Instructions
          _buildInstructions(res),
          
          SizedBox(height: res.hp(4)),
          
          // Verify payment button
          _buildVerifyButton(context, res),
          
          SizedBox(height: res.hp(2)),
        ],
      ),
    );
  }

  Widget _buildPaymentAmountCard(AutoResponsive res) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(5)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryBlue, darkBlue],
        ),
        borderRadius: BorderRadius.circular(res.wp(4)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.2),
            blurRadius: res.wp(3),
            offset: Offset(0, res.hp(0.5)),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Pembayaran',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: res.sp(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: res.hp(0.5)),
          Text(
            currencyFormat.format(kasirController.total),
            style: TextStyle(
              color: Colors.white,
              fontSize: res.sp(24),
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeContainer(File qrFile, AutoResponsive res) {
    return Container(
      padding: EdgeInsets.all(res.wp(6)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(res.wp(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: res.wp(4),
            offset: Offset(0, res.hp(0.5)),
          ),
        ],
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(res.wp(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: res.wp(2),
                  offset: Offset(0, res.hp(0.2)),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(res.wp(3)),
              child: Image.file(
                qrFile,
                width: res.wp(70),
                height: res.wp(70),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: res.hp(2)),
          Text(
            'Scan QR Code untuk pembayaran',
            style: TextStyle(
              color: textPrimary,
              fontSize: res.sp(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(AutoResponsive res) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(res.wp(3)),
        border: Border.all(color: primaryBlue.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: primaryBlue,
                size: res.sp(20),
              ),
              SizedBox(width: res.wp(2)),
              Text(
                'Cara Pembayaran:',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: res.hp(1.5)),
          _buildInstructionItem('1. Buka aplikasi mobile banking atau e-wallet', res),
          _buildInstructionItem('2. Pilih menu Scan QR atau QRIS', res),
          _buildInstructionItem('3. Arahkan kamera ke QR Code di atas', res),
          _buildInstructionItem('4. Konfirmasi pembayaran di aplikasi Anda', res),
          _buildInstructionItem('5. Tekan tombol "Verifikasi Pembayaran"', res),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text, AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.only(bottom: res.hp(0.8)),
      child: Text(
        text,
        style: TextStyle(
          color: textPrimary,
          fontSize: res.sp(14),
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildVerifyButton(BuildContext context, AutoResponsive res) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(3)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: res.wp(3),
            offset: Offset(0, res.hp(0.5)),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final double totalHarga = kasirController.total;
          final double jumlahUang = 0.0; // QRIS membayar tepat jumlah total
          final double kembalian = 0.0;

          // Navigasi ke halaman StrukPembayaran
          Get.to(() => StrukPembayaranPage(
            totalPembelian: totalHarga,
            uangTunai: jumlahUang,
            kembalian: kembalian,
            orderItems: kasirController.getOrderItems(),
            orderDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(8),
            vertical: res.hp(2.2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(3)),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_outlined,
              size: res.sp(20),
            ),
            SizedBox(width: res.wp(2)),
            Text(
              'Verifikasi Pembayaran',
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AutoResponsive res) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(res.wp(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: res.wp(32),
              height: res.wp(32),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.circular(res.wp(16)),
              ),
              child: Icon(
                Icons.qr_code_2_outlined,
                size: res.wp(16),
                color: primaryBlue,
              ),
            ),
            SizedBox(height: res.hp(3)),
            Text(
              'QR Code Tidak Ditemukan',
              style: TextStyle(
                color: textPrimary,
                fontSize: res.sp(20),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: res.hp(1)),
            Text(
              'Silakan unggah QR Code di pengaturan QRIS untuk menggunakan fitur pembayaran ini.',
              style: TextStyle(
                color: textSecondary,
                fontSize: res.sp(14),
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: res.hp(4)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(res.wp(3)),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.2),
                    blurRadius: res.wp(2),
                    offset: Offset(0, res.hp(0.3)),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.SETTING_Q_R_I_S),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(8),
                    vertical: res.hp(2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(3)),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: res.sp(18),
                    ),
                    SizedBox(width: res.wp(2)),
                    Text(
                      'Pengaturan QRIS',
                      style: TextStyle(
                        fontSize: res.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
