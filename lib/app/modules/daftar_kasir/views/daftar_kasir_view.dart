import 'package:apptiket/app/core/constants/api_constants.dart';
import 'package:apptiket/app/modules/kasir/views/kasir_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

// Modern color palette matching home_view.dart
const Color primaryBlue = Color(0xff181681);
const Color lightBlue = Color(0xFFE8E9FF);
const Color darkBlue = Color(0xff0F0B5C);
const Color accentBlue = Color(0xff2A23A3);
const Color backgroundColor = Color(0xFFFAFAFA);
const Color cardColor = Colors.white;
const Color textPrimary = Color(0xFF1F2937);
const Color textSecondary = Color(0xFF6B7280);
const Color borderColor = Color(0xFFE5E7EB);

class DaftarKasirView extends StatefulWidget {
  @override
  State<DaftarKasirView> createState() => _DaftarKasirViewState();
}

class _DaftarKasirViewState extends State<DaftarKasirView> {
  final DaftarKasirController controller = Get.put(DaftarKasirController());
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    controller.fetchProdukList();
    controller.fetchTiketList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.syncSelectedItems(); // Sync selected items
    });
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async{
          Get.offAllNamed(Routes.HOME);
          return false;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: _buildModernAppBar(res),
          body: Container(
            color: backgroundColor,
            child: Column(
              children: [
                // Shadow gradient effect
                Container(
                  height: res.hp(1.5),
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
                // TabBarView for content
                Expanded(
                  child: TabBarView(
                    children: [
                      Obx(() => _buildList(controller.filteredTiketList, 'tiket', res)),
                      Obx(() => _buildList(controller.filteredProdukList, 'produk', res)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(res),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar(AutoResponsive res) {
    return PreferredSize(
      preferredSize: Size.fromHeight(res.hp(14)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryBlue, darkBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar content
              Padding(
                padding: EdgeInsets.fromLTRB(res.wp(4), res.hp(1), res.wp(4), res.hp(0.5)),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(20)),
                      onPressed: () => Get.offAllNamed(Routes.HOME),
                    ),
                    SizedBox(width: res.wp(2)),
                    Expanded(
                      child: Text(
                        'Daftar Tiket dan Produk',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: res.sp(17),
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: res.wp(10)), // Balance the layout
                  ],
                ),
              ),
              // Tab bar
              Expanded(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: res.wp(5), vertical: res.hp(0.8)),
                        child: Text('Tiket'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: res.wp(5), vertical: res.hp(0.8)),
                        child: Text('Produk'),
                      ),
                    ),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  indicatorColor: Colors.white,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontSize: res.sp(15), 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: res.sp(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(
      List<Map<String, dynamic>> list, String type, AutoResponsive res) {
    return list.isEmpty
        ? _buildEmptyState(type, res)
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              String title =
                  item[type == 'produk' ? 'namaProduk' : 'namaTiket'] ?? '';
              double price =
                  double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: res.wp(4), vertical: res.hp(0.8)),
                child: _buildListItem(item, type, title, price, res),
              );
            },
          );
  }

  Widget _buildEmptyState(String type, AutoResponsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: res.wp(30),
            height: res.wp(30),
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined, 
              size: res.wp(15), 
              color: primaryBlue
            ),
          ),
          SizedBox(height: res.hp(2)),
          Text(
            'Tidak ada daftar $type yang dapat ditampilkan.',
            style: TextStyle(
              color: textSecondary,
              fontSize: res.sp(15),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            'Tambahkan $type baru melalui menu manajemen.',
            style: TextStyle(
              color: textSecondary.withOpacity(0.7),
              fontSize: res.sp(13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, String type, String title,
      double price, AutoResponsive res) {
    bool isSelected = controller.selectedItems.contains(item['id']);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(res.wp(4)),
          onTap: () => controller.addToCart(item),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(res.wp(4)),
              border: Border.all(
                color: isSelected ? primaryBlue : borderColor,
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: res.wp(3),
              vertical: res.hp(1.2),
            ),
            child: Row(
              children: [
                _buildItemImage(item, type, res),
                SizedBox(width: res.wp(4)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: res.sp(15),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: res.hp(0.5)),
                      Text(
                        currencyFormat.format(price),
                        style: TextStyle(
                          color: accentBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: res.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() => controller.selectedItems.contains(item['id'])
                    ? Container(
                        padding: EdgeInsets.all(res.wp(2)),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: primaryBlue, 
                          size: res.sp(20),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(res.wp(2)),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: textSecondary,
                          size: res.sp(20),
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

  Widget _buildItemImage(
      Map<String, dynamic> item, String type, AutoResponsive res) {
    if (type == 'produk' && item['image'] != null) {
      return Container(
        width: res.wp(15),
        height: res.wp(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(res.wp(3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: borderColor,
            width: 0.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(res.wp(3)),
          child: CachedNetworkImage(
            imageUrl: item['image'].startsWith('http')
                ? item['image']
                : ApiConstants.getStorageUrl(item['image']),
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingPlaceholder(res),
            errorWidget: (context, url, error) => _buildErrorImage(res),
            cacheManager: CacheManager(
              Config(
                'customCacheKey',
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 100,
                repo: JsonCacheInfoRepository(databaseName: 'customCacheKey'),
                fileService: HttpFileService(httpClient: http.Client()),
              ),
            ),
            fadeInDuration: const Duration(milliseconds: 500),
            fadeOutDuration: const Duration(milliseconds: 500),
          ),
        ),
      );
    } else if (type == 'tiket') {
      // For tickets without images, show a nice icon
      return Container(
        width: res.wp(15),
        height: res.wp(15),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(res.wp(3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(Icons.confirmation_number, size: res.sp(24), color: primaryBlue),
        ),
      );
    } else {
      return SizedBox(width: res.wp(15), height: res.wp(15));
    }
  }

  Widget _buildLoadingPlaceholder(AutoResponsive res) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Center(
        child: SizedBox(
          width: res.wp(6),
          height: res.wp(6),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(primaryBlue.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorImage(AutoResponsive res) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: res.sp(18), color: textSecondary),
            SizedBox(height: res.hp(0.5)),
            Text(
              'Tidak ada gambar',
              style: TextStyle(
                fontSize: res.sp(10),
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(AutoResponsive res) {
    return Container(
      width: res.wp(16),
      height: res.wp(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: primaryBlue,
        elevation: 0,
        onPressed: () {
          if (controller.pesananList.isEmpty) {
            Get.snackbar(
              'Pesanan Kosong',
              'Tambahkan produk atau tiket ke pesanan terlebih dahulu',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white,
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              boxShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10, 
                  offset: Offset(0, 2),
                ),
              ],
              duration: Duration(seconds: 2),
            );
          } else {
            Get.to(() => KasirView(pesananList: controller.pesananList));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: res.sp(22),
            ),
            Obx(() {
              return controller.pesananCount > 0
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(res.wp(1.2)),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          minWidth: res.wp(5),
                          minHeight: res.wp(5),
                        ),
                        child: Text(
                          controller.pesananCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: res.sp(10),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
