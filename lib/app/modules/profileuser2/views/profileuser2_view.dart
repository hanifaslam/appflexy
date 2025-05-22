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

class Profileuser2View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Profileuser2Controller>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff181681),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background decoration
            Container(
              height: 400,
              color: Color(0xff181681),
            ),
            // Profile container
            Padding(
              padding: const EdgeInsets.only(top: 120.0),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 60, bottom: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFEDEDED),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() {
                              if (controller.companyName.value.isEmpty) {
                                return CircularProgressIndicator();
                              }

                              return Text(
                                controller.companyName.value,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                            SizedBox(height: 15),
                            // Sales Info
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.trending_up,
                                          color: Colors.green, size: 30),
                                      SizedBox(height: 5),
                                      Text(
                                        'Penjualan',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                blurRadius: 5,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 5),
                                                FutureBuilder<
                                                    Map<String, dynamic>>(
                                                  future:
                                                      fetchOrdersWithTotalSales(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                        'Error: ${snapshot.error}',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      );
                                                    } else {
                                                      final totalSales =
                                                          snapshot.data![
                                                                  'total_sales']
                                                              as double;
                                                      return Text(
                                                        'Total Penjualan: Rp ${totalSales.toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Inter',
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            menuItem('Edit Profil Toko', Icons.edit, () async {
                              final result =
                                  await Get.toNamed(Routes.PENGATURAN_PROFILE);
                              if (result == true) {
                                controller.fetchCompanyDetails();
                              }
                            }),
                            menuItem('Ganti Password', Icons.lock, () {
                              Get.toNamed(Routes.GANTI_PASSWORD);
                            }),
                            menuItem('Edit / Tambah QR Code', Icons.qr_code,
                                () {
                              Get.toNamed(Routes.SETTING_Q_R_I_S);
                            }),
                            menuItem('Syarat & Ketentuan', Icons.description,
                                () {
                              Get.toNamed(Routes.SNK);
                            }),
                            menuItem('Keluar', Icons.exit_to_app, () {
                              _showLogoutDialog(context);
                            }, Colors.red),
                          ],
                        ),
                      ),
                      // Circle avatar above the box (now with synced image from profile)
                      Positioned(
                        top: -50,
                        left: 0,
                        right: 0,
                        child: Obx(() {
                          if (controller.companyLogo.value.isEmpty) {
                            return CircleAvatar(
                              radius: 55,
                              backgroundImage: AssetImage(
                                  'assets/logo/logoflex.png'), // Default logo
                            );
                          }

                          return CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: controller.companyLogo.value
                                        .startsWith('http')
                                    ? controller.companyLogo.value
                                    : ApiConstants.getStorageUrl(controller.companyLogo.value),
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    _buildLoadingPlaceholder(),
                                errorWidget: (context, url, error) {
                                  print('Error loading image: $error');
                                  return _buildErrorImage();
                                },
                                cacheManager: CacheManager(
                                  Config(
                                    'customCacheKey',
                                    stalePeriod: const Duration(days: 7),
                                    maxNrOfCacheObjects: 100,
                                    repo: JsonCacheInfoRepository(
                                        databaseName: 'customCacheKey'),
                                    fileService: HttpFileService(
                                        httpClient: http.Client()),
                                  ),
                                ),
                                fadeInDuration:
                                    const Duration(milliseconds: 500),
                                fadeOutDuration:
                                    const Duration(milliseconds: 500),
                                useOldImageOnUrlChange: true,
                                cacheKey: controller.companyLogo.value,
                                httpHeaders: {
                                  'Authorization':
                                      'Bearer ${controller.getToken()}',
                                  'Connection': 'keep-alive',
                                  'Keep-Alive': 'timeout=100, max=1000'
                                },
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
    );
  }

  // Placeholder for loading image
  Widget _buildLoadingPlaceholder() {
    return CircularProgressIndicator();
  }

  // Method to build error image
  Widget _buildErrorImage() {
    return Image.asset(
      'assets/logo/logoflex.png', // Default error image
      fit: BoxFit.cover,
    );
  }

  RxDouble totalSales = 0.0.obs;
  // Fetch orders with total sales
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

  // Menu item widget
  Widget menuItem(String title, IconData icon, Function onTap,
      [Color? textColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: textColor ?? Colors.black),
                  SizedBox(
                      width: 10), // Add some space between the icon and text
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor ?? Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward, color: textColor ?? Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  // Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          title: Center(
            child: Text(
              'Apakah anda yakin?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar? Anda perlu masuk kembali untuk mengakses akun Anda.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center, // Center the buttons
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog jika "Cancel"
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Text color
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                GetStorage().remove('token');
                GetStorage().remove('user_id');
                Get.toNamed(Routes.LOGIN); // Pindah ke halaman login
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Tombol "Delete" warna merah muda
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded button
                ),
              ),
              child: Text(
                'Keluar',
                style: TextStyle(color: Colors.white), // Warna teks putih
              ),
            ),
          ],
        );
      },
    );
  }
}
