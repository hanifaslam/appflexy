import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../edit_produk/controllers/edit_produk_controller.dart';
import '../controllers/daftar_produk_controller.dart';
import 'package:apptiket/app/modules/edit_produk/views/edit_produk_view.dart';
import 'package:apptiket/app/modules/tambah_produk/views/tambah_produk_view.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

// Custom ImageCacheManager class
class CustomCacheManager {
  static const key = 'customCacheKey';

  static final instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(httpClient: http.Client()),
    ),
  );
}

class DaftarProdukView extends StatelessWidget {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final DaftarProdukController controller = Get.put(DaftarProdukController());
  final EditProdukController editProdukController =
      Get.put(EditProdukController());

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff181681),
        toolbarHeight: res.hp(11),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: res.wp(3), vertical: res.hp(1)),
          child: TextField(
            onChanged: (query) => controller.updateSearchQuery(query),
            decoration: InputDecoration(
              hintText: 'Cari Nama Produk',
              prefixIcon: Icon(Icons.search_sharp),
              hintStyle: TextStyle(color: Color(0xff181681), fontSize: res.sp(14)),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[350],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(res.wp(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(res.wp(10)),
              ),
            ),
            style: TextStyle(fontSize: res.sp(14)),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showSortDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingShimmer(res);
        }

        if (controller.filteredProdukList.isEmpty) {
          return _buildEmptyState(res);
        }

        return Padding(
          padding: EdgeInsets.all(res.wp(2.5)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(res.wp(3)),
            ),
            padding: EdgeInsets.all(res.wp(2)),
            child: ListView.builder(
              itemCount: controller.filteredProdukList.length,
              itemBuilder: (context, index) {
                final produk = controller.filteredProdukList[index];
                return _buildProductCard(produk, index, res);
              },
            ),
          ),
        );
      }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(res.wp(3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(res.wp(1.5), res.hp(1.5)),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Color(0xff181681),
          onPressed: () async {
            final result = await Get.toNamed('/tambah-produk');
            if (result != null) {
              controller.fetchProducts();
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: res.sp(24),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer(AutoResponsive res) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(res.wp(2)),
            child: Container(
              height: res.hp(8),
              padding: EdgeInsets.all(res.wp(2)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AutoResponsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: res.wp(25),
            color: Colors.grey,
          ),
          SizedBox(height: res.hp(2)),
          Text(
            'Tidak ada daftar produk yang dapat ditampilkan.',
            style: TextStyle(color: Colors.grey, fontSize: res.sp(15)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: res.hp(1)),
          Text(
            'Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.',
            style: TextStyle(color: Colors.grey, fontSize: res.sp(13)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> produk, int index, AutoResponsive res) {
    double hargaJual = double.tryParse(produk['hargaJual'].toString()) ?? 0.0;
    String imageUrl = _getImageUrl(produk);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(res.wp(3), res.hp(2)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: res.hp(0.5)),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(3)),
          ),
          child: ListTile(
            leading: _buildProductImage(imageUrl, res),
            title: Text(
              produk['namaProduk'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(15)),
            ),
            subtitle: Text(
              'Stok: ${produk['stok']} | ${currencyFormat.format(hargaJual)}',
              style: TextStyle(fontSize: res.sp(13)),
            ),
            trailing: _buildPopupMenu(index, produk, res),
          ),
        ),
      ),
    );
  }

  String _getImageUrl(Map<String, dynamic> produk) {
    if (produk['image'] == null || produk['image'].toString().isEmpty)
      return '';

    try {
      if (produk['image'].toString().startsWith('http')) {
        return produk['image'];
      }
      final baseUrl = 'https://flexy.my.id';
      return '$baseUrl/storage/products/${produk['image']}';
    } catch (e) {
      print('Error generating image URL: $e');
      return '';
    }
  }

  Widget _buildProductImage(String imageUrl, AutoResponsive res) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage(res);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(res.wp(4)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: res.wp(12),
        height: res.wp(12),
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingPlaceholder(res),
        errorWidget: (context, url, error) {
          print('Error loading image: $error');
          return _buildErrorImage(res);
        },
        cacheManager: CustomCacheManager.instance,
        fadeInDuration: const Duration(milliseconds: 500),
        fadeOutDuration: const Duration(milliseconds: 500),
        useOldImageOnUrlChange: true,
        cacheKey: imageUrl,
        httpHeaders: const {
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

  Widget _buildPopupMenu(int index, Map<String, dynamic> produk, AutoResponsive res) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          _editProduk(index, produk);
        } else if (value == 'delete') {
          _showDeleteDialog(Get.context!, index, produk['id']);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: res.sp(16)),
              SizedBox(width: res.wp(2)),
              Text('Edit Produk', style: TextStyle(fontSize: res.sp(14))),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: res.sp(16)),
              SizedBox(width: res.wp(2)),
              Text('Hapus Produk', style: TextStyle(fontSize: res.sp(14))),
            ],
          ),
        ),
      ],
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort Produk"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Ascending"),
                onTap: () {
                  controller.sortFilteredProdukList(ascending: true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Descending"),
                onTap: () {
                  controller.sortFilteredProdukList(ascending: false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah yakin ingin menghapus barang ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                controller.deleteProduct(productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editProduk(int index, Map<String, dynamic> produk) {
    Get.to(() => EditProdukView(produk: produk, index: index))?.then((_) {
      // Refresh the product list after editing a product
      controller.fetchProducts();
    });
  }
}
