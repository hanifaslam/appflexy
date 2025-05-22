import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final box = GetStorage();
  var isLoading = false.obs;
  var pieChartData = <PieChartSectionData>[].obs;
  var totalOrders = 0.obs;
  var selectedFilter = 'Harian'.obs;
  var storeData = Rxn<Map<String, dynamic>>();
  var imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('HomeController onInit dipanggil');
    fetchCompanyDetails();
    fetchPieChartData(selectedFilter.value);
    checkStorageData(); // Panggil fungsi untuk cek data di GetStorage
  }

  String? getToken() => box.read('token');
  int? getUserId() => box.read('user_id');

  Future<void> fetchCompanyDetails() async {
    try {
      isLoading(true);
      final token = getToken();
      final userId = getUserId();

      // Menambahkan log untuk memastikan nilai user_id di GetStorage
      print('User ID yang ada di GetStorage: $userId');

      print('Token: $token');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }
      final response = await http.get(
        Uri.parse(ApiConstants.getFullUrl(ApiConstants.stores)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final List<dynamic> data = responseData['data'];
          print('Data stores: $data');

          final userStore = data.firstWhere(
            (store) => store['user_id'].toString() == userId.toString(),
            orElse: () {
              print('Store tidak ditemukan untuk user_id: $userId');
              return null;
            },
          );

          if (userStore != null) {
            storeData.value = {
              'nama_usaha': userStore['nama_usaha'] ?? 'Nama tidak ditemukan',
              'gambar': userStore['gambar'] ?? 'kosong',
            };
            print('Store data ditemukan: ${storeData.value}');
          } else {
            storeData.value = {
              'nama_usaha': 'Data tidak ditemukan',
              'gambar': 'kosong',
            };
          }
        } else {
          print('Data toko kosong atau tidak ditemukan');
          storeData.value = {
            'nama_usaha': 'Data tidak ditemukan',
            'gambar': 'default_image_url_or_placeholder',
          };
        }
      } else {
        throw Exception(
            'Failed to fetch store details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching company details: $e');
      Get.snackbar('Error', 'Failed to fetch company details');
    } finally {
      isLoading(false);
    }
  }

  void processPieChartData(dynamic data) {
    try {
      print('Raw data: $data');
      pieChartData.clear();
      totalOrders.value = 0;

      if (data is List) {
        final userId = getUserId(); // Get current user ID
        // Changed from Map check to List check
        final Map<String, double> orderCounts = {};
        final orders = data
            .where((order) => order['user_id'] == userId)
            .toList(); // Filter by user ID

        print('Processing orders for user $userId: ${orders.length}');

        for (var order in orders) {
          if (order['items'] != null && order['items'] is List) {
            for (var item in order['items']) {
              String itemName = item['name']?.toString() ?? 'Unknown';
              double itemPrice = 0.0;

              try {
                itemPrice =
                    double.parse(item['total_item_price']?.toString() ?? '0');
              } catch (e) {
                print('Error parsing price for $itemName: $e');
                continue;
              }

              orderCounts[itemName] = (orderCounts[itemName] ?? 0) + itemPrice;
              totalOrders.value += itemPrice.round();
            }
          }
        }

        print('Order counts: $orderCounts');
        print('Total orders: ${totalOrders.value}');

        if (totalOrders.value > 0) {
          var entries = orderCounts.entries.toList();
          entries.sort((a, b) => b.value.compareTo(a.value));

          pieChartData.value = List.generate(entries.length, (index) {
            final entry = entries[index];
            final percentage = (entry.value / totalOrders.value) * 100;

            return PieChartSectionData(
              color: Colors.primaries[index % Colors.primaries.length],
              value: percentage,
              title: '${percentage.toStringAsFixed(1)}%',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          });
        }
      }
      print('Pie chart sections: ${pieChartData.length}');
    } catch (e, stackTrace) {
      print('Error processing pie chart data: $e');
      print('Stack trace: $stackTrace');
    }
    update();
  }

  Future<void> fetchPieChartData(String filter) async {
    try {
      isLoading(true);
      final token = getToken();
      final userId = getUserId();

      print('Fetching pie chart data with filter: $filter');
      print('Token: $token');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/orders?filter=$filter&user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        processPieChartData(data);
      } else {
        throw Exception('Failed to load orders data');
      }
    } catch (e) {
      print('Error fetching pie chart data: $e');
      Get.snackbar('Error', 'Failed to load orders data');
    } finally {
      isLoading(false);
    }
  }

  void checkStorageData() {
    final userId = box.read('user_id');
    final token = box.read('token');

    if (userId == null || token == null) {
      print("Data tidak ditemukan di GetStorage");
    } else {
      print("User ID: $userId, Token: $token");
    }
  }

  void onFilterChanged(String filter) {
    selectedFilter.value = filter;
    fetchPieChartData(filter);
  }

  @override
  void onClose() {
    print('HomeController ditutup');
    super.onClose();
  }
}
