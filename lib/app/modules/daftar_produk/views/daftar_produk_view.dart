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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff181681),
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: TextField(
            onChanged: (query) => controller.updateSearchQuery(query),
            decoration: InputDecoration(
              hintText: 'Cari Nama Produk',
              prefixIcon: Icon(Icons.search_sharp),
              hintStyle: TextStyle(color: Color(0xff181681)),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[350],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
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
          return _buildLoadingShimmer();
        }

        if (controller.filteredProdukList.isEmpty) {
          return _buildEmptyState();
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.filteredProdukList.length,
              itemBuilder: (context, index) {
                final produk = controller.filteredProdukList[index];
                return _buildProductCard(produk, index);
              },
            ),
          ),
        );
      }),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(3, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Color(0xff181681),
          onPressed: () async {
            final result = await Get.to(() => TambahProdukView());
            if (result != null) {
              controller.fetchProducts();
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: Container(
              height: 80,
              padding: EdgeInsets.all(8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada daftar produk yang dapat ditampilkan.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> produk, int index) {
    double hargaJual = double.tryParse(produk['hargaJual'].toString()) ?? 0.0;
    String imageUrl = _getImageUrl(produk);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(6, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: _buildProductImage(imageUrl),
            title: Text(
              produk['namaProduk'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Stok: ${produk['stok']} | ${currencyFormat.format(hargaJual)}',
            ),
            trailing: _buildPopupMenu(index, produk),
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
      final baseUrl = 'https://cheerful-distinct-fox.ngrok-free.app';
      return '$baseUrl/storage/products/${produk['image']}';
    } catch (e) {
      print('Error generating image URL: $e');
      return '';
    }
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholderImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) {
          print('Error loading image: $error');
          return _buildErrorImage();
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.image,
        size: 30,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.broken_image,
        size: 30,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildPopupMenu(int index, Map<String, dynamic> produk) {
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
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit Produk'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Hapus Produk'),
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
