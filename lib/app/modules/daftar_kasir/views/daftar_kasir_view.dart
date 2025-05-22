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
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff181681),
          title: Text(
            'Daftar Tiket dan Produk',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: res.sp(17)),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tiket', height: res.hp(5)),
              Tab(text: 'Produk', height: res.hp(5)),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
            labelStyle:
                TextStyle(fontSize: res.sp(15), fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: res.sp(14)),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(20)),
            onPressed: () => Get.offAllNamed(Routes.HOME),
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildList(controller.filteredTiketList, 'tiket', res)),
            Obx(() => _buildList(controller.filteredProdukList, 'produk', res)),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(res),
      ),
    );
  }

  Widget _buildList(
      List<Map<String, dynamic>> list, String type, AutoResponsive res) {
    return list.isEmpty
        ? _buildEmptyState(type, res)
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              String title =
                  item[type == 'produk' ? 'namaProduk' : 'namaTiket'] ?? '';
              double price =
                  double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: res.wp(3.5), vertical: res.hp(0.7)),
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
          Icon(Icons.inbox, size: res.wp(25), color: Colors.grey),
          SizedBox(height: res.hp(2)),
          Text(
            'Tidak ada daftar $type yang dapat ditampilkan.',
            style: TextStyle(color: Colors.grey, fontSize: res.sp(15)),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item, String type, String title,
      double price, AutoResponsive res) {
    return Card(
      color: Color(0xffE3E3E3),
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(res.wp(3.5))),
      child: ListTile(
        leading: _buildItemImage(item, type, res),
        title: Text(title,
            style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(15))),
        subtitle: Text(currencyFormat.format(price),
            style: TextStyle(fontSize: res.sp(13))),
        trailing: Obx(() => controller.selectedItems.contains(item['id'])
            ? Icon(Icons.check_circle,
                color: Color(0xff181681), size: res.sp(20))
            : SizedBox.shrink()),
        onTap: () => controller.addToCart(item),
      ),
    );
  }

  Widget _buildItemImage(
      Map<String, dynamic> item, String type, AutoResponsive res) {
    if (type == 'produk' && item['image'] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(res.wp(4)),
        child: SizedBox(
          width: res.wp(13),
          height: res.wp(13),
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
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildLoadingPlaceholder(AutoResponsive res) {
    return Container(
      width: res.wp(13),
      height: res.wp(13),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(res.wp(4))),
      child: Center(
        child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!)),
      ),
    );
  }

  Widget _buildErrorImage(AutoResponsive res) {
    return Container(
      width: res.wp(13),
      height: res.wp(13),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(res.wp(4))),
      child:
          Icon(Icons.broken_image, size: res.sp(18), color: Colors.grey[600]),
    );
  }

  Widget _buildFloatingActionButton(AutoResponsive res) {
    return SizedBox(
      width: res.wp(17),
      height: res.wp(17),
      child: FloatingActionButton(
        backgroundColor: Color(0xff181681),
        onPressed: () {
          if (controller.pesananList.isEmpty) {
            Get.snackbar('Pesanan Kosong',
                'Tambahkan produk atau tiket ke pesanan terlebih dahulu',
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.to(() => KasirView(pesananList: controller.pesananList));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_cart, color: Colors.white, size: res.sp(24)),
            Obx(() {
              return controller.pesananCount > 0
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(res.wp(1.5)),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(res.wp(3))),
                        constraints: BoxConstraints(
                            minWidth: res.wp(5), minHeight: res.hp(2)),
                        child: Text(
                          controller.pesananCount.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(12),
                              fontWeight: FontWeight.bold),
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
