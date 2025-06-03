import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/sales_history_controller.dart';
import '../../../routes/app_pages.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

class SalesHistoryView extends StatelessWidget {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 2,
  );

  // Modern color palette - sama dengan home_view.dart
  static const Color primaryBlue = Color(0xff181681);
  static const Color lightBlue = Color(0xFFE8E9FF);
  static const Color darkBlue = Color(0xff0F0B5C);
  static const Color accentBlue = Color(0xff2A23A3);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final SalesHistoryController salesController = Get.find<SalesHistoryController>();
    final res = AutoResponsive(context);

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        return false; // Prevents the default back navigation
      },
      child: Scaffold(
        backgroundColor: primaryBlue, // Status bar akan mengikuti warna ini
        appBar: _buildModernAppBar(res, salesController),
        body: Container(
          color: backgroundColor,
          child: Column(
            children: [
              // Gradasi shadow di antara header dan content
              Container(
                height: res.hp(2.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      darkBlue.withOpacity(0.15),
                      darkBlue.withOpacity(0.10),
                      darkBlue.withOpacity(0.05),
                      Colors.black.withOpacity(0.03),
                      Colors.black.withOpacity(0.01),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                  ),
                ),
              ),
              Expanded(child: _buildBody(res, salesController)),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(AutoResponsive res, SalesHistoryController salesController) {
    return PreferredSize(
      preferredSize: Size.fromHeight(res.hp(18)), // Naikkan dari 16 ke 18
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryBlue,
              darkBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(0.8), res.wp(5), res.hp(1.2)), // Sesuaikan padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribusi lebih merata
              children: [
                // Header dengan back button dan title
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(20)), // Kurangi dari 22 ke 20
                      onPressed: () => Get.offAllNamed(Routes.HOME),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: res.wp(1)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Riwayat Penjualan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(18), // Kurangi dari 20 ke 18
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: res.hp(0.1)), // Kurangi dari 0.2 ke 0.1
                          Text(
                            'Laporan transaksi penjualan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: res.sp(12), // Kurangi dari 13 ke 12
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Filter button
                    _buildModernFilterButton(res, salesController),
                  ],
                ),
                
                // Stats summary
                _buildModernStatsRow(res, salesController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFilterButton(AutoResponsive res, SalesHistoryController salesController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(Icons.tune_rounded, color: Colors.white, size: res.sp(16)), // Kurangi dari 18 ke 16
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        padding: EdgeInsets.all(res.wp(1.5)), // Tambahkan padding kecil
        onSelected: (String value) {
          salesController.setFilter(value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'Semua',
            child: _buildFilterItem('Semua', Icons.all_inclusive, res),
          ),
          PopupMenuItem(
            value: 'Mingguan',
            child: _buildFilterItem('Mingguan', Icons.calendar_view_week, res),
          ),
          PopupMenuItem(
            value: 'Bulanan',
            child: _buildFilterItem('Bulanan', Icons.calendar_view_month, res),
          ),
          PopupMenuItem(
            value: 'Tahunan',
            child: _buildFilterItem('Tahunan', Icons.calendar_today, res),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(String title, IconData icon, AutoResponsive res) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue, size: res.sp(18)),
        SizedBox(width: res.wp(3)),
        Text(
          title,
          style: TextStyle(
            fontSize: res.sp(14),
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildModernStatsRow(AutoResponsive res, SalesHistoryController salesController) {
    return Obx(() {
      final totalTransactions = salesController.filteredSalesHistory.length;
      double totalRevenue = 0.0;
      
      for (var sale in salesController.filteredSalesHistory) {
        totalRevenue += double.tryParse(sale['total']?.toString() ?? '0') ?? 0.0;
      }

      return Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric( // Ubah padding
                horizontal: res.wp(2.5),
                vertical: res.hp(0.8),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '$totalTransactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: res.sp(14), // Kurangi dari 16 ke 14
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Transaksi',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: res.sp(10), // Kurangi dari 11 ke 10
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: res.wp(2)), // Kurangi dari 3 ke 2
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric( // Ubah padding
                horizontal: res.wp(2.5),
                vertical: res.hp(0.8),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _formatCompactCurrency(totalRevenue),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: res.sp(14), // Kurangi dari 16 ke 14
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Total Revenue',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: res.sp(10), // Kurangi dari 11 ke 10
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  String _formatCompactCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }

  Widget _buildBody(AutoResponsive res, SalesHistoryController salesController) {
    return Obx(() {
      if (salesController.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                  backgroundColor: lightBlue,
                ),
              ),
              SizedBox(height: res.hp(2)),
              Text(
                'Memuat riwayat penjualan...',
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

      if (salesController.filteredSalesHistory.isEmpty) {
        return _buildModernEmptyState(res);
      }

      return _buildModernSalesList(res, salesController);
    });
  }

  Widget _buildModernEmptyState(AutoResponsive res) {
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.bar_chart_outlined,
                size: res.wp(16),
                color: primaryBlue,
              ),
            ),
            SizedBox(height: res.hp(3)),
            Text(
              'Belum ada riwayat penjualan',
              style: TextStyle(
                color: textPrimary,
                fontSize: res.sp(20),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: res.hp(1)),
            Text(
              'Transaksi penjualan akan muncul di sini setelah Anda melakukan penjualan',
              style: TextStyle(
                color: textSecondary,
                fontSize: res.sp(14),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSalesList(AutoResponsive res, SalesHistoryController salesController) {
    return Padding(
      padding: EdgeInsets.all(res.wp(5)),
      child: ListView.builder(
        itemCount: salesController.filteredSalesHistory.length,
        itemBuilder: (context, index) {
          final sale = salesController.filteredSalesHistory[index];
          return _buildModernSalesCard(sale, salesController, res, index);
        },
      ),
    );
  }

  Widget _buildModernSalesCard(
      Map<String, dynamic> sale, SalesHistoryController salesController, AutoResponsive res, int index) {
    final double total = double.tryParse(sale['total']?.toString() ?? '0') ?? 0.0;
    final String customer = sale['customer'] ?? 'Customer ${index + 1}';
    final String time = sale['time'] ?? 'Waktu tidak tersedia';
    final String paymentMethod = sale['payment_method'] ?? 'Tidak diketahui';
    final List items = sale['items'] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: borderColor,
          width: 0.5,
        ),
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(res.wp(4)),
          childrenPadding: EdgeInsets.fromLTRB(res.wp(4), 0, res.wp(4), res.wp(4)),
          leading: Container(
            width: res.wp(12),
            height: res.wp(12),
            decoration: BoxDecoration(
              color: accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: accentBlue,
              size: res.sp(24),
            ),
          ),
          title: Text(
            customer,
            style: TextStyle(
              color: textPrimary,
              fontSize: res.sp(16),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: res.hp(0.5)),
              Text(
                _formatDateTime(time),
                style: TextStyle(
                  color: textSecondary,
                  fontSize: res.sp(12),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: res.hp(0.3)),
              Text(
                currencyFormat.format(total),
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: res.sp(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          children: [
            _buildModernSaleDetails(sale, salesController, res),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSaleDetails(
      Map<String, dynamic> sale, SalesHistoryController salesController, AutoResponsive res) {
    final String paymentMethod = sale['payment_method'] ?? 'Tidak diketahui';
    final List items = sale['items'] ?? [];
    final double total = double.tryParse(sale['total']?.toString() ?? '0') ?? 0.0;

    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method
          Row(
            children: [
              Icon(Icons.payment, color: primaryBlue, size: res.sp(16)),
              SizedBox(width: res.wp(2)),
              Text(
                'Metode Pembayaran:',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: res.sp(13),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(2.5),
                  vertical: res.hp(0.5),
                ),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  paymentMethod,
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (items.isNotEmpty) ...[
            SizedBox(height: res.hp(1.5)),
            Row(
              children: [
                Icon(Icons.shopping_bag_outlined, color: primaryBlue, size: res.sp(16)),
                SizedBox(width: res.wp(2)),
                Text(
                  'Detail Items:',
                  style: TextStyle(
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: res.sp(13),
                  ),
                ),
              ],
            ),
            SizedBox(height: res.hp(1)),
            ...items.map<Widget>((item) => _buildModernItemRow(item, res)).toList(),
          ],

          SizedBox(height: res.hp(1.5)),
          Container(
            padding: EdgeInsets.all(res.wp(3)),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Transaksi:',
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: res.sp(15),
                  ),
                ),
                Text(
                  currencyFormat.format(total),
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: res.sp(16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernItemRow(Map<String, dynamic> item, AutoResponsive res) {
    final String name = item['name'] ?? 'Item tidak diketahui';
    final int quantity = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
    final double price = double.tryParse(item['total_item_price']?.toString() ?? '0') ?? 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: res.hp(0.8)),
      padding: EdgeInsets.all(res.wp(2.5)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: res.wp(8),
            height: res.wp(8),
            decoration: BoxDecoration(
              color: Color(0xFFFF8C00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.confirmation_num_outlined,
              color: Color(0xFFFF8C00),
              size: res.sp(16),
            ),
          ),
          SizedBox(width: res.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: res.sp(13),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Qty: $quantity',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: res.sp(11),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormat.format(price),
            style: TextStyle(
              color: primaryBlue,
              fontSize: res.sp(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
      return formatter.format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}
