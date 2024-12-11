// ignore_for_file: avoid_print

import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';

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
    homeController.fetchBarChartData(); // Fetch chart data when initializing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181681),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBackground(),
          _buildContent(),
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

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 150,
      backgroundColor: const Color(0xff181681),
      elevation: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 5.0),
        child: const Text(
          "Flexy",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 50,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: Get.height,
      width: Get.width,
      color: const Color(0xff181681),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _buildUserInfoSection(),
          const SizedBox(height: 20),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: const Color(0xff365194).withOpacity(1),
        borderRadius: BorderRadius.circular(20),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/logo/logoflex.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "AmbatuJawir",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Farhan Kebab",
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularIconButton(
                    Icons.confirmation_num_outlined,
                    'Data',
                    'Tiket',
                    const Color(0xffFFAF00),
                    Colors.white,
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
                    onTap: () {
                      Get.toNamed(Routes.DAFTAR_PRODUK);
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

  Widget _buildBottomSection() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(37),
            topRight: Radius.circular(37),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Obx(() {
          if (homeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (homeController.barChartData.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Icon(
                    CupertinoIcons.cube_box,
                    size: 150,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    'Tidak ada daftar produk yang dapat ditampilkan. Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return _buildLineChart();
          }
        }),
      ),
    );
  }

  Widget _buildLineChart() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Transform.translate(
        offset: const Offset(-10, 20), // Move left by 20 and down by 20
        child: Flexible(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: homeController.barChartData.map((groupData) {
                    return FlSpot(
                        groupData.x.toDouble(), groupData.barRods.first.toY);
                  }).toList(),
                  isCurved: true,
                  color: Colors.blueAccent,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.3),
                        Colors.blueAccent.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              borderData: FlBorderData(
                show: false,
                border: Border(
                  left: BorderSide(color: Colors.black, width: 1),
                  bottom: BorderSide(color: Colors.black, width: 1),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent),
                ),
              ),
              gridData: FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 300000,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value / 1000).toInt()}K',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                    reservedSize: 50,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          homeController.monthLabels[value.toInt()],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              minY: 0,
              maxY: 1200000,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIconButton(
    IconData icon,
    String label1,
    String label2,
    Color circleColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 35,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
          Text(
            label2,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
