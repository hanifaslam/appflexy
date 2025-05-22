import 'dart:convert';

import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:apptiket/app/core/utils/auto_responsive.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

import '../../../core/utils/cloud_painter.dart';
import '../../../core/utils/wave_painter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const Center(child: Text('Beranda', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Penjualan', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Settings', style: TextStyle(fontSize: 24))),
  ];

  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.fetchPieChartData(homeController.selectedFilter.value);
    homeController.fetchCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      backgroundColor: const Color(0xff181681),
      appBar: _buildAppBar(res),
      body: Stack(
        children: [
          _buildBackground(res),
          _buildContent(res),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
            if (index == 0) {
              Get.offAllNamed(Routes.HOME);
            } else if (index == 1) {
              Get.offAllNamed(Routes.DAFTAR_KASIR);
            } else if (index == 2) {
              Get.offAllNamed(Routes.PROFILEUSER2);
            }
          });
        },
      ),
    );
  }

  AppBar _buildAppBar(AutoResponsive res) {
  return AppBar(
    toolbarHeight: res.hp(18),
    backgroundColor: const Color(0xff181681),
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tulisan Flexy
        Container(
          padding: EdgeInsets.only(top: res.hp(0.5)),
          child: Text(
            "Flexy",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: res.sp(40),
              fontWeight: FontWeight.normal,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.blueAccent.withOpacity(0.25),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
              letterSpacing: 2,
            ),
          ),
        ),
        // Modern, playful, gradient abstract art + soft cloud
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Blurred neon ellipse
            Container(
              width: res.wp(13),
              height: res.hp(6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8EC5FC).withOpacity(0.85),
                    const Color(0xFF6E61E6).withOpacity(0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(res.wp(8)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8EC5FC).withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 4,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
            ),
            // Wavy line overlay
            Positioned(
              top: res.hp(1.2),
              left: res.wp(2.5),
              child: Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: res.wp(7),
                  height: res.hp(1.2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF6E61E6).withOpacity(0.7),
                        const Color(0xFF8EC5FC).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Dot accent
            Positioned(
              right: res.wp(1.5),
              bottom: res.hp(0.7),
              child: Container(
                width: res.wp(1.7),
                height: res.wp(1.7),
                decoration: BoxDecoration(
                  color: const Color(0xFF6E61E6).withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6E61E6).withOpacity(0.25),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            // Soft cloud shape (awan)
            Positioned(
              left: res.wp(5),
              bottom: res.hp(0.5),
              child: Opacity(
                opacity: 1,
                child: CustomPaint(
                  size: Size(res.wp(8), res.hp(2.5)),
                  painter: CloudPainter(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildBackground(AutoResponsive res) {
    return Stack(
      children: [
        // Main dark blue background
        Container(
          height: res.height,
          width: res.width,
          color: const Color(0xff181681),
        ),
        // Top-right abstract wave
        Positioned(
          top: -res.hp(8),
          right: -res.wp(20),
          child: CustomPaint(
            size: Size(res.wp(80), res.hp(30)),
            painter: WavePainter(
              colors: [
                const Color(0xFF8EC5FC).withOpacity(0.22), // Light blue
                const Color(0xFF6E61E6).withOpacity(0.18), // Purple
              ],
            ),
          ),
        ),
        // Bottom-right abstract wave
        Positioned(
          bottom: -res.hp(10),
          right: -res.wp(25),
          child: CustomPaint(
            size: Size(res.wp(100), res.hp(35)),
            painter: WavePainter(
              colors: [
                const Color(0xFF8EC5FC).withOpacity(0.16),
                const Color(0xFF6E61E6).withOpacity(0.13),
              ],
              reverse: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(AutoResponsive res) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: res.hp(1)),
          child: Column(
            children: [
              _buildUserInfoSection(res),
              SizedBox(height: res.hp(2)),
            ],
          ),
        ),
        _buildPieChartSection(res),
      ],
    );
  }

  Widget _buildUserInfoSection(AutoResponsive res) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: res.wp(6)),
      decoration: BoxDecoration(
        color: const Color(0xff365194).withOpacity(1),
        borderRadius: BorderRadius.circular(res.wp(5)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(5)),
        child: Column(
          children: [
            Row(
              children: [
                Obx(() {
                  if (homeController.isLoading.value) {
                    return SizedBox(
                      width: res.wp(12),
                      height: res.wp(12),
                      child: const CircularProgressIndicator(),
                    );
                  }

                  final storeData = homeController.storeData.value;
                  final imageUrl = storeData?['gambar'];

                  return _buildProductImage(imageUrl ?? '', res);
                }),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: Obx(() {
                    if (homeController.isLoading.value) {
                      return const CircularProgressIndicator();
                    }

                    final storeData = homeController.storeData.value;
                    return Text.rich(
                      TextSpan(
                        text: 'Selamat Datang, ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: res.sp(14),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: storeData?['nama_usaha'] ?? 'Nama tidak ditemukan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontSize: res.sp(14),
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: res.hp(1)),
            Container(
              margin: EdgeInsets.only(top: res.hp(1)),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(res.wp(5))),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: res.hp(2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularIconButton(
                    Icons.confirmation_num_outlined,
                    'Data',
                    'Tiket',
                    const Color(0xffFFAF00),
                    Colors.white,
                    res,
                    onTap: () {
                      Get.offAllNamed(Routes.MANAJEMEN_TIKET);
                    },
                  ),
                  _buildCircularIconButton(
                    Icons.bar_chart,
                    'Riwayat',
                    'Penjualan',
                    const Color(0xff5475F9),
                    Colors.white,
                    res,
                    onTap: () {
                      Get.offAllNamed(Routes.SALES_HISTORY);
                    },
                  ),
                  _buildCircularIconButton(
                    CupertinoIcons.cube_box,
                    'Data',
                    'Produk',
                    const Color(0xffF95454),
                    Colors.white,
                    res,
                    onTap: () {
                      Get.offAllNamed(Routes.DAFTAR_PRODUK);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartSection(AutoResponsive res) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.7,
      snap: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.98),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(res.wp(10)),
                topRight: Radius.circular(res.wp(10)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Obx(() {
                if (homeController.isLoading.value) {
                  return SizedBox(
                    height: res.hp(65),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff181681)),
                        strokeWidth: 3,
                      ),
                    ),
                  );
                } else if (homeController.pieChartData.isEmpty) {
                  return SizedBox(
                    height: res.hp(65),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(res.wp(7)),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.cube_box,
                            size: res.wp(18),
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: res.hp(3)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: res.wp(10)),
                          child: Text(
                            'Tidak ada data pesanan yang dapat ditampilkan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: res.sp(14),
                              height: 1.5,
                              color: Color(0xFF757575),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: res.wp(10),
                        height: res.hp(0.5),
                        margin: EdgeInsets.only(top: res.hp(1.5)),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(res.wp(2)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          res.wp(6),
                          res.hp(3),
                          res.wp(6),
                          res.hp(2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Catatan Penjualan',
                              style: TextStyle(
                                fontSize: res.sp(16),
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(res.wp(3)),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: res.wp(2),
                                vertical: res.hp(0.3),
                              ),
                              child: DropdownButton<String>(
                                value: homeController.selectedFilter.value,
                                underline: SizedBox(),
                                icon: Icon(Icons.keyboard_arrow_down, size: res.sp(16)),
                                items: <String>['Harian', 'Mingguan', 'Bulanan']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: res.sp(12),
                                        color: Color(0xFF2D2D2D),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  homeController.onFilterChanged(newValue!);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildPieChart(res),
                      SizedBox(height: res.hp(3)),
                    ],
                  );
                }
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPieChart(AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        children: [
          SizedBox(height: res.hp(5)),
          SizedBox(
            width: res.wp(55),
            height: res.wp(55),
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sections: homeController.pieChartData.map((data) {
                      return PieChartSectionData(
                        color: data.color,
                        value: data.value,
                        title: '${data.value.toStringAsFixed(1)}%',
                        radius: res.wp(14),
                        titleStyle: TextStyle(
                          fontSize: res.sp(10),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: res.wp(20),
                  ),
                ),
                Center(
                  child: Text(
                    'Total\nPesanan:\nRp. ${NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(homeController.totalOrders.value)}',
                    style: TextStyle(
                      fontSize: res.sp(14),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularIconButton(
    IconData icon,
    String label1,
    String label2,
    Color circleColor,
    Color iconColor,
    AutoResponsive res, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: res.wp(18),
            height: res.wp(18),
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: res.sp(22),
            ),
          ),
          SizedBox(height: res.hp(0.7)),
          Text(
            label1,
            style: TextStyle(
              color: Colors.black,
              fontSize: res.sp(12),
              fontFamily: 'Inter',
            ),
          ),
          Text(
            label2,
            style: TextStyle(
              color: Colors.black,
              fontSize: res.sp(12),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imageUrl, AutoResponsive res) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage(res);
    }

    final token = homeController.getToken();

    return ClipRRect(
      borderRadius: BorderRadius.circular(res.wp(4)),      child: CachedNetworkImage(
        imageUrl: imageUrl.startsWith('http')
            ? imageUrl
            : ApiConstants.getStorageUrl(imageUrl),
        width: res.wp(12),
        height: res.wp(12),
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingPlaceholder(res),
        errorWidget: (context, url, error) {
          print('Error loading image: $error');
          return _buildErrorImage(res);
        },
        cacheManager: CacheManager(
          Config(
            'customCacheKey',
            stalePeriod: const Duration(days: 7),
            maxNrOfCacheObjects: 100,
            repo: JsonCacheInfoRepository(databaseName: 'customCacheKey'),
            fileService: HttpFileService(httpClient: http.Client()),
          ),
        ) as BaseCacheManager?,
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 500),
        useOldImageOnUrlChange: true,
        cacheKey: imageUrl,
        httpHeaders: {
          'Authorization': 'Bearer $token',
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=100, max=1000'
        },
      ),
    );
  }

  Widget _buildPlaceholderImage(AutoResponsive res) {
    return Container(
      width: res.wp(12),
      height: res.wp(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      child: Icon(
        Icons.image,
        size: res.sp(18),
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildLoadingPlaceholder(AutoResponsive res) {
    return Container(
      width: res.wp(12),
      height: res.wp(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
        ),
      ),
    );
  }

  Widget _buildErrorImage(AutoResponsive res) {
    return Container(
      width: res.wp(12),
      height: res.wp(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(4)),
      ),
      child: Icon(
        Icons.broken_image,
        size: res.sp(18),
        color: Colors.grey[600],
      ),
    );
  }
}

