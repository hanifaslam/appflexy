import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../profileuser2/controllers/profileuser2_controller.dart';
import 'package:apptiket/app/widgets/navbar.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchCompanyDetails() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/stores'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      return {
        'nama_usaha': data[0]
        ['nama_usaha'], // Ambil nama usaha dari store pertama
        'gambar': data[0]['gambar'], // Ambil gambar
      };
    } else {
      throw Exception('No stores found');
    }
  } else {
    throw Exception('Failed to load company details');
  }
}

Future<Map<String, dynamic>> fetchOrdersWithTotalSales() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/orders'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> orders = data;

    // Hitung total penjualan dari total_item_price
    double totalSales = 0.0;

    for (var order in orders) {
      final items = order['items'] as List<dynamic>;
      for (var item in items) {
        final itemTotal =
            double.tryParse(item['total_item_price'].toString()) ?? 0.0;
        totalSales += itemTotal;
      }
    }

    return {
      'orders': orders, // Semua data order
      'total_sales': totalSales, // Total penjualan
    };
  } else {
    throw Exception('Failed to load orders');
  }
}

class Profileuser2View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Profileuser2Controller>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF213F84),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background decoration
            Container(
              height: 400,
              color: Color(0xFF213F84),
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
                            FutureBuilder<Map<String, dynamic>>(
                              future: fetchCompanyDetails(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Gagal memuat nama perusahaan',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    snapshot.data!['nama_usaha'] ??
                                        'Nama tidak ditemukan',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 30),
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
                                      Icon(Icons.arrow_downward,
                                          color: Colors.green, size: 30),
                                      SizedBox(height: 5),
                                      Text(
                                        'Penjualan',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter',
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(height: 5),
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
                            menuItem('Edit Profil Toko', Icons.edit, () {
                              // Navigate to profile settings
                              Get.toNamed(Routes
                                  .PENGATURAN_PROFILE); // Navigasi ke halaman pengaturan profil
                            }),
                            menuItem('Ganti Password', Icons.lock, () {
                              // Navigate to change password
                              Get.toNamed(Routes.GANTI_PASSWORD);
                            }),
                            menuItem('Edit / Tambah QR Code', Icons.lock, () {
                              // Navigate to change password
                              Get.toNamed(Routes.SETTING_Q_R_I_S);
                            }),
                            menuItem('Syarat & Ketentuan', Icons.description,
                                    () {
                                  // Navigate to terms and conditions
                                  // Get.toNamed(Routes.SYARAT_KETENTUAN);
                                }),
                            menuItem('Keluar', Icons.delete, () {
                              // Navigate to delete account
                              Get.toNamed(Routes.LOGIN);
                            }, Colors.red),
                          ],
                        ),
                      ),
                      // Circle avatar above the box (now with synced image from profile)
                      Positioned(
                          top: -50,
                          left: 0,
                          right: 0,
                          child: FutureBuilder<Map<String, dynamic>>(
                            future: fetchCompanyDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return CircleAvatar(
                                  radius: 55,
                                  backgroundImage: AssetImage(
                                      'assets/logo/logoflex.png'), // Default logo
                                );
                              } else {
                                final imageUrl = snapshot.data!['gambar'];

                                if (imageUrl == null || imageUrl.isEmpty) {
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
                                      imageUrl: imageUrl.startsWith('http')
                                          ? imageUrl
                                          : 'http://10.0.2.2:8000/storage/images/$imageUrl',
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            'assets/logo/logoflex.png', // Gambar fallback jika error
                                            fit: BoxFit.cover,
                                          ),
                                      fit: BoxFit.cover,
                                      width: 110,
                                      height: 110,
                                    ),
                                  ),
                                );
                              }
                            },
                          ))
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

  // Background circle decoration
  Widget circleDecoration(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFADD8E7).withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
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
}
