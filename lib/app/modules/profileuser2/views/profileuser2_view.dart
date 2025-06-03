import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../profileuser2/controllers/profileuser2_controller.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/auto_responsive.dart';

class Profileuser2View extends StatelessWidget {
  final RxDouble totalSales = 0.0.obs;

  Profileuser2View({Key? key}) : super(key: key);

  // Modern color palette matching HomeView theme
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
    final controller = Get.find<Profileuser2Controller>();
    final res = AutoResponsive(context);

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME); // Navigate to home on back press
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        backgroundColor: primaryBlue,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryBlue,
          title: Text(
            'Profil Toko',
            style: TextStyle(
              fontSize: res.sp(18),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Background decoration with gradient
              Container(
                height: res.hp(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryBlue, darkBlue],
                  ),
                ),
              ),
              
              // Profile content container
              Padding(
                padding: EdgeInsets.only(top: res.hp(10)),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Main white container
                        Container(
                          padding: EdgeInsets.only(
                            top: res.hp(7),
                            bottom: res.hp(3),
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(res.wp(8)),
                              topRight: Radius.circular(res.wp(8)),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: Offset(0, -3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Company name display
                              Obx(() {
                                if (controller.companyName.value.isEmpty) {
                                  return SizedBox(
                                    height: res.hp(3),
                                    width: res.wp(30),
                                    child: Center(
                                      child: LinearProgressIndicator(
                                        backgroundColor: lightBlue,
                                        valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                                      ),
                                    ),
                                  );
                                }
      
                                return Text(
                                  controller.companyName.value,
                                  style: TextStyle(
                                    fontSize: res.sp(22),
                                    fontWeight: FontWeight.w700,
                                    color: textPrimary,
                                    height: 1.2,
                                    letterSpacing: -0.3,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }),
                              
                              SizedBox(height: res.hp(2.5)),
                              
                              // Sales statistics card with modern design
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: res.wp(5)),
                                child: Container(
                                  padding: EdgeInsets.all(res.wp(5)),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(res.wp(4)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
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
                                      // Title with icon
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(res.wp(2)),
                                            decoration: BoxDecoration(
                                              color: accentBlue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(res.wp(2)),
                                            ),
                                            child: Icon(
                                              Icons.trending_up,
                                              color: accentBlue,
                                              size: res.wp(5),
                                            ),
                                          ),
                                          SizedBox(width: res.wp(3)),
                                          Text(
                                            'Statistik Penjualan',
                                            style: TextStyle(
                                              fontSize: res.sp(16),
                                              fontWeight: FontWeight.w700,
                                              color: textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      SizedBox(height: res.hp(2)),
                                      
                                      // Sales amount display
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: res.hp(2.5),
                                          horizontal: res.wp(4),
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              lightBlue,
                                              primaryBlue.withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(res.wp(3)),
                                          border: Border.all(
                                            color: primaryBlue.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: FutureBuilder<Map<String, dynamic>>(
                                          future: fetchOrdersWithTotalSales(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(
                                                child: SizedBox(
                                                  height: res.hp(5),
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                    valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                padding: EdgeInsets.all(res.wp(3)),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  borderRadius: BorderRadius.circular(res.wp(2)),
                                                  border: Border.all(color: Colors.red.shade200),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                      size: res.wp(5),
                                                    ),
                                                    SizedBox(width: res.wp(2)),
                                                    Flexible(
                                                      child: Text(
                                                        'Error memuat data: ${snapshot.error}',
                                                        style: TextStyle(
                                                          color: Colors.red.shade700,
                                                          fontSize: res.sp(14),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {                                              final totalSales = snapshot.data!['total_sales'] as double;
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Total Penjualan',
                                                      style: TextStyle(
                                                        fontSize: res.sp(14),
                                                        fontWeight: FontWeight.w500,
                                                        color: textSecondary,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(height: res.hp(1)),
                                                  Container(
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Rp ${totalSales.toStringAsFixed(0)}',
                                                      style: TextStyle(
                                                        fontSize: res.sp(24),
                                                        fontWeight: FontWeight.w700,
                                                        color: primaryBlue,
                                                        letterSpacing: -0.5,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: res.hp(3)),
                              
                              // Menu items
                              _buildMenuItem(
                                context,
                                'Edit Profil Toko', 
                                Icons.edit, 
                                () async {
                                  final result = await Get.toNamed(Routes.PENGATURAN_PROFILE);
                                  if (result == true) {
                                    controller.fetchCompanyDetails();
                                  }
                                },
                              ),
                              _buildMenuItem(
                                context,
                                'Ganti Password', 
                                Icons.lock, 
                                () {
                                  Get.toNamed(Routes.GANTI_PASSWORD);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                'Edit / Tambah QR Code', 
                                Icons.qr_code, 
                                () {
                                  Get.toNamed(Routes.SETTING_Q_R_I_S);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                'Syarat & Ketentuan', 
                                Icons.description, 
                                () {
                                  Get.toNamed(Routes.SNK);
                                },
                              ),
                              _buildMenuItem(
                                context,
                                'Keluar', 
                                Icons.exit_to_app, 
                                () {
                                  _showLogoutDialog(context, res);
                                },
                                isLogout: true,
                              ),
                            ],
                          ),
                        ),
                        
                        // Avatar positioned on top
                        Positioned(
                          top: -res.wp(12),
                          left: 0,
                          right: 0,
                          child: Obx(() {
                            if (controller.companyLogo.value.isEmpty) {
                              return Container(
                                width: res.wp(24),
                                height: res.wp(24),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: res.wp(12),
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage('assets/logo/logoflex.png'),
                                ),
                              );
                            }
      
                            return Container(
                              width: res.wp(24),
                              height: res.wp(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: res.wp(12),
                                backgroundColor: Colors.grey.shade200,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: controller.companyLogo.value.startsWith('http')
                                        ? controller.companyLogo.value
                                        : ApiConstants.getStorageUrl(controller.companyLogo.value),
                                    width: res.wp(24),
                                    height: res.wp(24),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => _buildLoadingPlaceholder(),
                                    errorWidget: (context, url, error) {
                                      print('Error loading image: $error');
                                      return _buildErrorImage();
                                    },
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
                                    useOldImageOnUrlChange: true,
                                    cacheKey: controller.companyLogo.value,
                                    httpHeaders: {
                                      'Authorization': 'Bearer ${controller.getToken()}',
                                      'Connection': 'keep-alive',
                                      'Keep-Alive': 'timeout=100, max=1000'
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavigationBar(
          currentIndex: 2, // Tab index
          onTap: (index) {
            // Navigation based on tab
            if (index == 0) {
              Get.offAllNamed(Routes.HOME); // Go to Home
            } else if (index == 1) {
              Get.offAllNamed(Routes.DAFTAR_KASIR); // Go to Kasir
            } else if (index == 2) {
              // Stay on profile
            }
          },
        ),
      ),
    );
  }

  // Build menu item with modern style
  Widget _buildMenuItem(
    BuildContext context, 
    String title, 
    IconData icon, 
    Function onTap, 
    {bool isLogout = false}
  ) {
    final res = AutoResponsive(context);
    final Color itemColor = isLogout ? Colors.red : primaryBlue;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: res.wp(5),
        vertical: res.hp(1),
      ),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(res.wp(3)),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: res.hp(2),
            horizontal: res.wp(4),
          ),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(res.wp(3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: borderColor,
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(res.wp(2)),
                    decoration: BoxDecoration(
                      color: isLogout 
                          ? Colors.red.withOpacity(0.1)
                          : accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(res.wp(2)),
                    ),
                    child: Icon(
                      icon, 
                      color: itemColor,
                      size: res.wp(5),
                    ),
                  ),
                  SizedBox(width: res.wp(3)),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: res.sp(15),
                      fontWeight: FontWeight.w600,
                      color: isLogout ? Colors.red : textPrimary,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: itemColor,
                size: res.wp(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern loading placeholder
  Widget _buildLoadingPlaceholder() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
      strokeWidth: 3,
    );
  }

  // Method to build error image
  Widget _buildErrorImage() {
    return Image.asset(
      'assets/logo/logoflex.png',
      fit: BoxFit.cover,
    );
  }

  // Fetch orders with total sales - keeping existing logic
  Future<Map<String, dynamic>> fetchOrdersWithTotalSales() async {
    final box = GetStorage();
    final token = box.read('token');
    final userId = box.read('user_id');

    if (token == null || userId == null) {
      throw Exception('Authentication required');
    }

    final response = await http.get(
      Uri.parse(ApiConstants.getFullUrl('/orders?user_id=$userId')),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> allOrders = json.decode(response.body);
      final List<dynamic> userOrders =
          allOrders.where((order) => order['user_id'] == userId).toList();

      double total = userOrders.fold(
          0.0, (sum, order) => sum + double.parse(order['total'].toString()));

      return {
        'orders': userOrders,
        'total_sales': total,
      };
    } else {
      throw Exception('Failed to load orders');
    }
  }

  // Show logout confirmation dialog with modern UI
  void _showLogoutDialog(BuildContext context, AutoResponsive res) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                        Colors.red.shade300,
                        Colors.red.shade700,
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
                  "Apakah Anda yakin ingin keluar? Anda perlu masuk kembali untuk mengakses akun Anda.",
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          GetStorage().remove('token');
                          GetStorage().remove('user_id');
                          Get.toNamed(Routes.LOGIN);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
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
    );
  }
}
