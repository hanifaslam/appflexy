import 'package:apptiket/app/modules/kasir/views/kasir_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';

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
                color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tiket'),
              Tab(text: 'Produk'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.offAllNamed(Routes.HOME),
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildList(controller.filteredTiketList, 'tiket')),
            Obx(() => _buildList(controller.filteredProdukList, 'produk')),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list, String type) {
    return list.isEmpty
        ? _buildEmptyState(type)
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              String title =
                  item[type == 'produk' ? 'namaProduk' : 'namaTiket'] ?? '';
              double price =
                  double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0.0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                child: _buildListItem(item, type, title, price),
              );
            },
          );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada daftar $type yang dapat ditampilkan.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      Map<String, dynamic> item, String type, String title, double price) {
    return Card(
      color: Color(0xffE3E3E3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: ListTile(
        leading: _buildItemImage(item, type),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(currencyFormat.format(price)),
        trailing: Obx(() => controller.selectedItems.contains(item['id'])
            ? Icon(Icons.check_circle, color: Color(0xff181681))
            : SizedBox.shrink()),
        onTap: () => controller.addToCart(item),
      ),
    );
  }

  Widget _buildItemImage(Map<String, dynamic> item, String type) {
    if (type == 'produk' && item['image'] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 50,
          height: 50,
          child: CachedNetworkImage(
            imageUrl: item['image'].startsWith('http')
                ? item['image']
                : 'https://cheerful-distinct-fox.ngrok-free.app/storage/${item['image']}',
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingPlaceholder(),
            errorWidget: (context, url, error) => _buildErrorImage(),
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
      return Icon(Icons.image, size: 50);
    }
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!)),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Icon(Icons.broken_image, size: 30, color: Colors.grey[600]),
    );
  }

  Widget _buildFloatingActionButton() {
    return SizedBox(
      width: 65,
      height: 65,
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
            Icon(Icons.shopping_cart, color: Colors.white, size: 30),
            Obx(() {
              return controller.pesananCount > 0
                  ? Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12)),
                        constraints:
                            BoxConstraints(minWidth: 20, minHeight: 10),
                        child: Text(
                          controller.pesananCount.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
