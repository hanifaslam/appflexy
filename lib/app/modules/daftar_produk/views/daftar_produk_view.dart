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
import 'package:apptiket/app/core/utils/auto_responsive.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';
import '../../../routes/app_pages.dart';

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
  final EditProdukController editProdukController = Get.put(EditProdukController());

  // Modern color palette - sama dengan manajemen_tiket_view
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
    final res = AutoResponsive(context);

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Get.offAllNamed(Routes.HOME);
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: primaryBlue,
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
        floatingActionButton: _buildModernFAB(res),
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
            padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(0.5), res.wp(5), res.hp(1.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Header dengan back button dan title
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(22)),
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
                            'Daftar Produk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(20),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: res.hp(0.2)),
                          Text(
                            'Kelola produk untuk disewakan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: res.sp(13),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Sort button
                    _buildModernSortButton(res),
                  ],
                ),
                
                // Search bar
                _buildModernSearchBar(res),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchBar(AutoResponsive res) {
    return Container(
      height: res.hp(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        onChanged: (query) => controller.updateSearchQuery(query),
        style: TextStyle(
          color: Colors.white,
          fontSize: res.sp(14),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Cari nama produk...',
          hintStyle: TextStyle(
            color: Colors.white60,
            fontSize: res.sp(14),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white70,
            size: res.sp(20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: res.wp(4),
            vertical: res.hp(1.2),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSortButton(AutoResponsive res) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(Icons.sort_rounded, color: Colors.white, size: res.sp(18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        padding: EdgeInsets.all(res.wp(1.5)),
        onSelected: (String value) {
          if (value == 'asc') {
            controller.sortFilteredProdukList(ascending: true);
          } else if (value == 'desc') {
            controller.sortFilteredProdukList(ascending: false);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'asc',
            child: _buildSortItem('A - Z', Icons.arrow_upward, res),
          ),
          PopupMenuItem(
            value: 'desc',
            child: _buildSortItem('Z - A', Icons.arrow_downward, res),
          ),
        ],
      ),
    );
  }

  Widget _buildSortItem(String title, IconData icon, AutoResponsive res) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue, size: res.sp(16)),
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

  Widget _buildBody(AutoResponsive res) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                'Memuat data produk...',
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

      if (controller.filteredProdukList.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.fetchProducts(),
          color: primaryBlue,
          child: _buildModernEmptyState(res),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchProducts(),
        color: primaryBlue,
        child: _buildModernProdukList(res),
      );
    });
  }

  Widget _buildModernEmptyState(AutoResponsive res) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
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
                    Icons.inventory_2_outlined,
                    size: res.wp(16),
                    color: primaryBlue,
                  ),
                ),
                SizedBox(height: res.hp(3)),
                Text(
                  'Belum ada produk',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: res.sp(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: res.hp(1)),
                Text(
                  'Mulai dengan menambahkan produk pertama Anda',
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
      ],
    );
  }

  Widget _buildModernProdukList(AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.all(res.wp(5)),
      child: ListView.builder(
        itemCount: controller.filteredProdukList.length,
        itemBuilder: (context, index) {
          return _buildModernProdukCard(context, index, res);
        },
      ),
    );
  }

  Widget _buildModernProdukCard(BuildContext context, int index, AutoResponsive res) {
    final produk = controller.filteredProdukList[index];
    final double hargaJual = double.tryParse(produk['hargaJual'].toString()) ?? 0.0;
    final int stok = int.tryParse(produk['stok'].toString()) ?? 0;
    final String namaProduk = produk['namaProduk']?.toString() ?? 'Nama produk tidak tersedia';
    String imageUrl = _getImageUrl(produk);

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
          // Header dengan gambar produk dan menu
          Row(
            children: [
              // Gambar produk
              _buildModernProductImage(imageUrl, res),
              SizedBox(width: res.wp(3)),
              
              // Info produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaProduk,
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
                    SizedBox(height: res.hp(0.3)),
                    Text(
                      produk['kategori']?.toString() ?? 'Tanpa kategori',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: res.sp(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu button
              _buildModernPopupMenu(context, index, produk, res),
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
              color: stok > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: stok > 0 ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stok > 0 ? Icons.inventory_2_outlined : Icons.warning_outlined,
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
                if (stok <= 5 && stok > 0) ...[
                  SizedBox(width: res.wp(2)),
                  Text(
                    '(Stok menipis)',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: res.sp(11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernProductImage(String imageUrl, AutoResponsive res) {
    return Container(
      width: res.wp(16),
      height: res.wp(16),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageUrl.isEmpty
            ? Icon(
                Icons.image_outlined,
                color: primaryBlue,
                size: res.sp(24),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholderFadeInDuration: Duration(milliseconds: 200),
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: primaryBlue,
                    strokeWidth: 2,
                  ),
                ),
                errorWidget: (context, url, error) {
                  print('Error loading image: $url - Error: $error');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_outlined,
                        color: Colors.red[300],
                        size: res.sp(20),
                      ),
                      SizedBox(height: res.hp(0.5)),
                      Text(
                        'Gagal memuat',
                        style: TextStyle(
                          fontSize: res.sp(8),
                          color: Colors.red[300],
                        ),
                      ),
                    ],
                  );
                },
                cacheManager: CustomCacheManager.instance,
                httpHeaders: {'Accept': 'image/*'},
              ),
      ),
    );
  }

  Widget _buildModernPopupMenu(BuildContext context, int index, Map<String, dynamic> produk, AutoResponsive res) {
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
            _editProduk(index, produk);
          } else if (value == 'delete') {
            _showModernDeleteDialog(context, index, produk['id']);
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
                  'Edit Produk',
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
                  'Hapus Produk',
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

  Widget _buildModernFAB(AutoResponsive res) {
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
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Get.to(() => TambahProdukView());
          if (result != null) {
            controller.fetchProducts();
          }
        },
        icon: Icon(Icons.add, size: res.sp(20)),
        label: Text(
          'Tambah Produk',
          style: TextStyle(
            fontSize: res.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showModernDeleteDialog(BuildContext context, int index, int productId) {
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
            "Apakah Anda yakin ingin menghapus produk ini? Tindakan ini tidak dapat dibatalkan.",
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                "Hapus",
                style: TextStyle(
                  fontSize: res.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
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
  String _getImageUrl(Map<String, dynamic> produk) {
    if (produk['image'] == null || produk['image'].toString().isEmpty) {
      print('Debug: No image found for product ${produk['namaProduk']}');
      return '';
    }

    try {
      // Print the raw image value for debugging
      print('Debug: Raw image value: ${produk['image']}');
      
      // Handle fully qualified URLs from the API
      if (produk['image'].toString().startsWith('http')) {
        print('Debug: Using direct URL: ${produk['image']}');
        return produk['image'];
      }
      
      // Fix for Android: Try using direct IP instead of 10.0.2.2
      // This bypasses potential Android network security issues
      String imagePath = produk['image'].toString();
      
      // Remove leading slashes to prevent double slashes in URL
      if (imagePath.startsWith('/')) {
        imagePath = imagePath.substring(1);
      }
      
      // Use IP directly to avoid Android issues with 10.0.2.2
      final url = 'http://10.0.2.2:8000/storage/products/$imagePath';
      print('Debug: Direct URL: $url');
      
      return url;
    } catch (e) {
      print('Error generating image URL: $e');
      return '';
    }
  }

  void _editProduk(int index, Map<String, dynamic> produk) {
    Get.to(() => EditProdukView(produk: produk, index: index))?.then((_) {
      controller.fetchProducts();
    });
  }
}
