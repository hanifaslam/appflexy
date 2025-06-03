import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _pageIndex = 0;
  final HomeController homeController = Get.put(HomeController());

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
  @override
  void initState() {
    super.initState();
    homeController.fetchCompanyDetails();
    homeController
        .fetchLineChartData(homeController.selectedLineChartFilter.value);
    homeController.fetchRecentTransactions();
  }
  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context, res);
      },
      child: Scaffold(
        backgroundColor: primaryBlue, // Status bar akan mengikuti warna ini
        appBar: _buildModernAppBar(res),
        body: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            child: _buildContent(res),
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (index) {
            setState(() {
              _pageIndex = index;
              if (index == 0) {
                Get.offAllNamed(Routes.HOME);
              } else if (index == 1) {
                Get.toNamed(Routes.DAFTAR_KASIR);
              } else if (index == 2) {
                Get.toNamed(Routes.PROFILEUSER2);
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildContent(AutoResponsive res) {
    return Column(
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
        _buildUserInfoSection(res),
      ],
    );
  }

  PreferredSizeWidget _buildModernAppBar(AutoResponsive res) {
    return PreferredSize(
      preferredSize:
          Size.fromHeight(res.hp(14)), // Tingkatkan dari hp(15) ke hp(16)
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
            padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(0.5), res.wp(5),
                res.hp(1.5)), // Kurangi padding top dan bottom
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Header greeting
                Obx(() {
                  if (homeController.isLoading.value) {
                    return Row(
                      children: [
                        SizedBox(
                          height: 18, // Kurangi dari 20 ke 18
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: res.wp(3)),
                        Text(
                          'Memuat...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }

                  final storeData = homeController.storeData.value;
                  final namaUser =
                      storeData?['nama_usaha'] ?? 'Nama tidak ditemukan';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: res.sp(14),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                          height:
                              res.hp(0.3)), // Kurangi dari hp(0.5) ke hp(0.3)
                      Text(
                        namaUser,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: res.sp(22), // Kurangi dari sp(24) ke sp(22)
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }),
                SizedBox(height: res.hp(1)), // Kurangi dari hp(1.5) ke hp(1)
                // Date display
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(3),
                    vertical: res.hp(0.6), // Kurangi dari hp(0.8) ke hp(0.6)
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getCurrentDate(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: res.sp(11), // Kurangi dari sp(12) ke sp(11)
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];

    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
  
  Future<bool> _showExitConfirmationDialog(BuildContext context, AutoResponsive res) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(5)),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(res.wp(5)),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(res.wp(4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: res.wp(5),
                  offset: Offset(0, res.hp(1)),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon in gradient circle
                Container(
                  width: res.wp(20),
                  height: res.wp(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryBlue.withOpacity(0.8),
                        darkBlue,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                    size: res.wp(10),
                  ),
                ),
                
                SizedBox(height: res.hp(2.5)),
                
                // Title
                Text(
                  "Keluar Aplikasi",
                  style: TextStyle(
                    fontSize: res.sp(18),
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                
                SizedBox(height: res.hp(1)),
                
                // Message
                Text(
                  "Apakah Anda yakin ingin keluar dari aplikasi?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: res.sp(14),
                    color: textSecondary,
                  ),
                ),
                
                SizedBox(height: res.hp(3)),
                
                // Button row
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: textPrimary,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(res.wp(2.5)),
                            side: BorderSide(color: borderColor),
                          ),
                        ),
                        child: Text(
                          "Batal",
                          style: TextStyle(
                            fontSize: res.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: res.wp(3)),
                    
                    // Exit button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(res.wp(2.5)),
                          ),
                        ),
                        child: Text(
                          "Keluar",
                          style: TextStyle(
                            fontSize: res.sp(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ) ?? false; // Default to false if dialog is dismissed
  }

  Widget _buildUserInfoSection(AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: res.wp(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu section title
          Text(
            'Menu Utama',
            style: TextStyle(
              color: textPrimary,
              fontSize: res.sp(18),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: res.hp(2)),

          // Menu cards
          _buildModernMenuCard(
            icon: Icons.confirmation_num_outlined,
            label: 'Data Tiket',
            subtitle: 'Kelola tiket acara Anda',
            color: const Color(0xFFFF8C00),
            res: res,
            onTap: () => Get.toNamed(Routes.MANAJEMEN_TIKET),
          ),
          SizedBox(height: res.hp(1.5)),

          _buildModernMenuCard(
            icon: Icons.bar_chart_rounded,
            label: 'Riwayat Penjualan',
            subtitle: 'Lihat laporan penjualan',
            color: accentBlue,
            res: res,
            onTap: () => Get.toNamed(Routes.SALES_HISTORY),
          ),
          SizedBox(height: res.hp(1.5)),

          _buildModernMenuCard(
            icon: CupertinoIcons.cube_box_fill,
            label: 'Data Produk',
            subtitle: 'Atur produk dan stok',
            color: const Color(0xFFEF4444),
            res: res,
            onTap: () => Get.toNamed(Routes.DAFTAR_PRODUK),
          ),

          SizedBox(height: res.hp(4)),

          // Analytics section
          Text(
            'Analitik',
            style: TextStyle(
              color: textPrimary,
              fontSize: res.sp(18),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: res.hp(2)),

          // Line Chart Section
          _buildModernLineChartSection(res),
          SizedBox(height: res.hp(3)),

          // Recent Transactions Section
          _buildModernRecentTransactionsSection(res),
          SizedBox(height: res.hp(3)),
        ],
      ),
    );
  }

  Widget _buildModernMenuCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required AutoResponsive res,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(res.wp(4)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: borderColor,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: res.wp(12),
                  height: res.wp(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: res.sp(24),
                  ),
                ),
                SizedBox(width: res.wp(4)),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: res.hp(0.3)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: res.sp(13),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: textSecondary,
                  size: res.sp(16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernLineChartSection(AutoResponsive res) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
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
          // Header with filter
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pendapatan',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: res.sp(18),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: res.hp(0.3)),
                    Text(
                      'Grafik penjualan terkini',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: res.sp(13),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Modern filter button
              Container(
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.tune_rounded,
                    color: primaryBlue,
                    size: res.sp(20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  onSelected: (value) {
                    homeController.selectedLineChartFilter.value = value;
                    homeController.fetchLineChartData(value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'two_months',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_view_month,
                              color: primaryBlue, size: 18),
                          SizedBox(width: 8),
                          Text('Per 2 Bulan'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'day',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: primaryBlue, size: 18),
                          SizedBox(width: 8),
                          Text('Per Hari'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: res.hp(3)),

          // Chart content
          Obx(() {
            if (homeController.isLoadingLineChart.value) {
              return Container(
                height: res.hp(25),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryBlue),
                          backgroundColor: lightBlue,
                        ),
                      ),
                      SizedBox(height: res.hp(2)),
                      Text(
                        'Memuat data...',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: res.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = homeController.lineChartData;

            if (data.isEmpty) {
              return Container(
                height: res.hp(25),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.insert_chart_outlined,
                        color: textSecondary,
                        size: res.sp(48),
                      ),
                      SizedBox(height: res.hp(1)),
                      Text(
                        'Tidak ada data',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: res.hp(0.5)),
                      Text(
                        'Filter: ${homeController.selectedLineChartFilter.value}',
                        style: TextStyle(
                          color: textSecondary.withOpacity(0.7),
                          fontSize: res.sp(12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              height: res.hp(30),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: borderColor,
                      strokeWidth: 0.5,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: borderColor,
                      strokeWidth: 0.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          if (value == 0)
                            return Text('0',
                                style: TextStyle(
                                  fontSize: res.sp(10),
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ));

                          if (value >= 1000000) {
                            return Text(
                                '${(value / 1000000).toStringAsFixed(1)}M',
                                style: TextStyle(
                                  fontSize: res.sp(10),
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ));
                          } else if (value >= 1000) {
                            return Text('${(value / 1000).toStringAsFixed(0)}K',
                                style: TextStyle(
                                  fontSize: res.sp(10),
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ));
                          } else {
                            return Text(value.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: res.sp(10),
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ));
                          }
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.length)
                            return const SizedBox();

                          String label = data[index].label;

                          if (homeController.selectedLineChartFilter.value ==
                              'two_months') {
                            final monthMap = {
                              'Januari': 'Jan',
                              'Maret': 'Mar',
                              'Mei': 'Mei',
                              'Juli': 'Jul',
                              'September': 'Sep',
                              'November': 'Nov',
                            };
                            label = monthMap[label] ?? label.substring(0, 3);
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: res.sp(10),
                                color: textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0; i < data.length; i++)
                          FlSpot(i.toDouble(), data[i].value),
                      ],
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: primaryBlue,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: cardColor,
                            strokeWidth: 3,
                            strokeColor: primaryBlue,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primaryBlue.withOpacity(0.2),
                            accentBlue.withOpacity(0.1),
                            lightBlue.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModernRecentTransactionsSection(AutoResponsive res) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaksi Terbaru',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: res.sp(18),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: res.hp(0.3)),
                  Text(
                    '5 transaksi terakhir',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: res.sp(13),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.offAllNamed(Routes.SALES_HISTORY),
                style: TextButton.styleFrom(
                  foregroundColor: primaryBlue,
                  padding: EdgeInsets.symmetric(
                    horizontal: res.wp(3),
                    vertical: res.hp(1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: res.sp(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: res.wp(1)),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: res.sp(12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: res.hp(2.5)),

          // Transactions list
          Obx(() {
            if (homeController.isLoadingRecentTransactions.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: res.hp(3)),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryBlue),
                          backgroundColor: lightBlue,
                        ),
                      ),
                      SizedBox(height: res.hp(1.5)),
                      Text(
                        'Memuat transaksi...',
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: res.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final transactions = homeController.recentTransactions;

            if (transactions.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: res.hp(4)),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: textSecondary,
                      size: res.sp(48),
                    ),
                    SizedBox(height: res.hp(1)),
                    Text(
                      'Belum ada transaksi',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: res.sp(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: res.hp(0.5)),
                    Text(
                      'Transaksi akan muncul di sini',
                      style: TextStyle(
                        color: textSecondary.withOpacity(0.7),
                        fontSize: res.sp(12),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;
                return _buildModernTransactionCard(transaction, res,
                    isLast: index == transactions.length - 1);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildModernTransactionCard(
      Map<String, dynamic> transaction, AutoResponsive res,
      {bool isLast = false}) {
    double total =
        double.tryParse(transaction['total']?.toString() ?? '0') ?? 0.0;

    String formattedDate = 'Tanggal tidak tersedia';
    if (transaction['time'] != null) {
      try {
        final date = DateTime.parse(transaction['time']);
        formattedDate =
            '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    String itemsDisplay = 'Tidak ada item';
    if (transaction['items'] != null &&
        transaction['items'] is List &&
        transaction['items'].isNotEmpty) {
      final items = transaction['items'] as List;
      if (items.length == 1) {
        itemsDisplay = items[0]['name'] ?? 'Item tidak diketahui';
      } else {
        itemsDisplay =
            '${items[0]['name'] ?? 'Item'} (+${items.length - 1} lainnya)';
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : res.hp(1.5)),
      padding: EdgeInsets.all(res.wp(3.5)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Transaction icon
          Container(
            width: res.wp(11),
            height: res.wp(11),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_outlined,
              color: primaryBlue,
              size: res.sp(20),
            ),
          ),

          SizedBox(width: res.wp(3.5)),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemsDisplay,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: res.sp(14),
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: res.hp(0.3)),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Transaction amount
          Text(
            homeController.formatCurrency(total),
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: res.sp(15),
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}
