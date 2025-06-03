import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/modules/tambah_tiket/views/tambah_tiket_view.dart';
import 'package:apptiket/app/modules/manajemen_tiket/controllers/manajemen_tiket_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

class ManajemenTiketView extends GetView<ManajemenTiketController> {
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

  ManajemenTiketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        return false; // Mencegah navigasi default
      },
      child: Scaffold(
        backgroundColor: primaryBlue, // Status bar akan mengikuti warna ini
        appBar: _buildModernAppBar(res),
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
              Expanded(child: _buildBody(res)),
            ],
          ),
        ),
        floatingActionButton: _buildModernFloatingActionButton(context, res),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(AutoResponsive res) {
    return PreferredSize(
      preferredSize: Size.fromHeight(res.hp(16)),
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
            padding: EdgeInsets.fromLTRB(
                res.wp(5), res.hp(0.5), res.wp(5), res.hp(1.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Header dengan back button dan title
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Colors.white, size: res.sp(24)),
                      onPressed: () => Get.offAllNamed(Routes.HOME),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: res.wp(2)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Data Tiket',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(22),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: res.hp(0.3)),
                          Text(
                            'Kelola tiket acara Anda',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: res.sp(14),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sort button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.sort,
                            color: Colors.white, size: res.sp(20)),
                        onPressed: () => _showModernSortDialog(Get.context!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: res.hp(1)),
                // Search field
                _buildModernSearchField(res),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchField(AutoResponsive res) {
    return Container(
      height: res.hp(5.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari nama tiket...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: textSecondary,
            size: res.sp(20),
          ),
          hintStyle: TextStyle(
            color: textSecondary,
            fontSize: res.sp(14),
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: res.wp(4),
            vertical: res.hp(1.5),
          ),
        ),
        style: TextStyle(
          fontSize: res.sp(14),
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBody(AutoResponsive res) {
    return Obx(() {
      if (controller.isLoading.value) {
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
                'Memuat data tiket...',
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

      if (controller.filteredTiketList.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          color: primaryBlue,
          child: _buildModernEmptyState(res),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        color: primaryBlue,
        child: _buildModernTiketList(res),
      );
    });
  }

  Widget _buildModernEmptyState(AutoResponsive res) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          height: Get.height * 0.7, // Gunakan Get.height daripada MediaQuery
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(res.wp(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: res.wp(32),
                    height: res.wp(32),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.confirmation_num_outlined,
                      size: res.wp(16),
                      color: primaryBlue,
                    ),
                  ),
                  SizedBox(height: res.hp(3)),
                  Text(
                    'Belum ada tiket',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: res.sp(20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: res.hp(1)),
                  Text(
                    'Mulai dengan menambahkan tiket pertama Anda',
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
          ),
        ),
      ],
    );
  }

  Widget _buildModernTiketList(AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.all(res.wp(5)),
      child: ListView.builder(
        itemCount: controller.filteredTiketList.length,
        itemBuilder: (context, index) =>
            _buildModernTiketCard(context, index, res),
      ),
    );
  }

  Widget _buildModernTiketCard(
      BuildContext context, int index, AutoResponsive res) {
    final tiket = controller.filteredTiketList[index];
    final double hargaJual =
        double.tryParse(tiket['hargaJual'].toString()) ?? 0.0;
    final int stok = int.tryParse(tiket['stok'].toString()) ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: res.hp(2)),
      padding: EdgeInsets.all(res.wp(4)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan nama tiket dan menu
          Row(
            children: [
              // Nama tiket
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tiket['namaTiket'] ?? 'Nama tiket tidak tersedia',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: res.sp(16),
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: res.hp(0.3)),
                    Text(
                      currencyFormat.format(hargaJual),
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: res.sp(15),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu button
              _buildModernPopupMenu(context, index, tiket, res),
            ],
          ),

          SizedBox(height: res.hp(1.5)),

          // Stok information
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(3),
              vertical: res.hp(0.8),
            ),
            decoration: BoxDecoration(
              color: stok > 0
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: stok > 0
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stok > 0
                      ? Icons.inventory_2_outlined
                      : Icons.warning_outlined,
                  color: stok > 0 ? Colors.green : Colors.red,
                  size: res.sp(16),
                ),
                SizedBox(width: res.wp(2)),
                Text(
                  'Stok: $stok',
                  style: TextStyle(
                    color: stok > 0 ? Colors.green : Colors.red,
                    fontSize: res.sp(13),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPopupMenu(BuildContext context, int index,
      Map<String, dynamic> tiket, AutoResponsive res) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: textSecondary,
          size: res.sp(20),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        onSelected: (value) {
          if (value == 'edit') {
            _editTiket(context, index, tiket);
          } else if (value == 'delete') {
            _showModernDeleteDialog(context, tiket['id']);
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, color: primaryBlue, size: res.sp(18)),
                SizedBox(width: res.wp(3)),
                Text(
                  'Edit Tiket',
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, color: Colors.red, size: res.sp(18)),
                SizedBox(width: res.wp(3)),
                Text(
                  'Hapus Tiket',
                  style: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFloatingActionButton(
      BuildContext context, AutoResponsive res) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Get.to(() => TambahTiketView());
          if (result != null) {
            controller.fetchTikets();
          }
        },
        icon: Icon(Icons.add, size: res.sp(20)),
        label: Text(
          'Tambah Tiket',
          style: TextStyle(
            fontSize: res.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showModernSortDialog(BuildContext context) {
    final res = AutoResponsive(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Urutkan Tiket",
            style: TextStyle(
              color: textPrimary,
              fontSize: res.sp(18),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption(
                context: context,
                title: "A-Z (Ascending)",
                icon: Icons.sort_by_alpha,
                onTap: () {
                  controller.sortTikets(true);
                  Navigator.of(context).pop();
                },
                res: res,
              ),
              SizedBox(height: res.hp(1)),
              _buildSortOption(
                context: context,
                title: "Z-A (Descending)",
                icon: Icons.sort_by_alpha,
                onTap: () {
                  controller.sortTikets(false);
                  Navigator.of(context).pop();
                },
                res: res,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required AutoResponsive res,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: res.hp(1.5),
          horizontal: res.wp(3),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryBlue, size: res.sp(20)),
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
        ),
      ),
    );
  }

  void _showModernDeleteDialog(BuildContext context, int tiketId) {
    final res = AutoResponsive(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_outlined, color: Colors.red, size: res.sp(24)),
              SizedBox(width: res.wp(2)),
              Text(
                "Konfirmasi Hapus",
                style: TextStyle(
                  color: textPrimary,
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus tiket ini? Tindakan ini tidak dapat dibatalkan.",
            style: TextStyle(
              color: textSecondary,
              fontSize: res.sp(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Batal",
                style: TextStyle(
                  color: textSecondary,
                  fontSize: res.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Hapus",
                          style: TextStyle(
                            fontSize: res.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          Navigator.of(context).pop();
                          await controller.deleteTiket(tiketId);
                        },
                )),
          ],
        );
      },
    );
  }

  void _editTiket(
      BuildContext context, int index, Map<String, dynamic> tiket) async {
    if (tiket.isEmpty) return;

    final int tiketId = tiket['id'];
    final result =
        await Get.to(() => TambahTiketView(tiket: tiket, index: index));

    if (result == 'success') {
      // Data sudah di-refresh dari TambahTiketView, tidak perlu refresh lagi
      print('Tiket berhasil diupdate dan data telah di-refresh');
    }
  }
}
