import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../core/constants/api_constants.dart';

class SalesHistoryController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  // Observable variables
  var salesHistory = <Map<String, dynamic>>[].obs;
  var filteredSalesHistory = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var selectedFilter = 'Semua'.obs;
  
  // Getter untuk token dan user ID
  String? get token => _storage.read('token');
  int? get userId => _storage.read('user_id');

  @override
  void onInit() {
    super.onInit();
    fetchSalesHistory();
  }

  Future<void> fetchSalesHistory() async {
    try {
      isLoading.value = true;
      
      print('Fetching sales history...');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        salesHistory.value = data
            .where((order) => order['user_id'] == userId)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        filteredSalesHistory.value = List.from(salesHistory);
        applyFilter();
        
        print('Sales history loaded: ${salesHistory.length} items');
      } else {
        throw Exception('Failed to load sales history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sales history: $e');
      Get.snackbar(
        'Error',
        'Failed to load sales history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilter();
  }

  void applyFilter() {
    try {
      isLoading.value = true;
      
      if (selectedFilter.value == 'Semua') {
        filteredSalesHistory.value = List.from(salesHistory);
      } else {
        final now = DateTime.now();
        DateTime filterDate;

        switch (selectedFilter.value) {
          case 'Mingguan':
            filterDate = now.subtract(Duration(days: 7));
            break;
          case 'Bulanan':
            filterDate = now.subtract(Duration(days: 30));
            break;
          case 'Tahunan':
            filterDate = now.subtract(Duration(days: 365));
            break;
          default:
            filterDate = DateTime(1970); // Semua data
        }

        filteredSalesHistory.value = salesHistory.where((sale) {
          try {
            final saleDate = DateTime.parse(sale['time'] ?? '');
            return saleDate.isAfter(filterDate);
          } catch (e) {
            print('Error parsing date for sale: ${sale['time']}');
            return false;
          }
        }).toList();
      }
      
      // Sort by date (newest first)
      filteredSalesHistory.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['time'] ?? '');
          final dateB = DateTime.parse(b['time'] ?? '');
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      print('Filtered sales history: ${filteredSalesHistory.length} items');
    } catch (e) {
      print('Error applying filter: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk refresh data
  Future<void> refreshData() async {
    await fetchSalesHistory();
  }

  // Method untuk format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // Method untuk get total revenue
  double getTotalRevenue() {
    double total = 0.0;
    for (var sale in filteredSalesHistory) {
      total += double.tryParse(sale['total']?.toString() ?? '0') ?? 0.0;
    }
    return total;
  }

  // Method untuk get total transactions
  int getTotalTransactions() {
    return filteredSalesHistory.length;
  }

  // Method untuk get revenue by period
  Map<String, double> getRevenueByPeriod() {
    Map<String, double> revenueMap = {};
    
    for (var sale in filteredSalesHistory) {
      try {
        final saleDate = DateTime.parse(sale['time'] ?? '');
        final monthYear = DateFormat('MM-yyyy').format(saleDate);
        final revenue = double.tryParse(sale['total']?.toString() ?? '0') ?? 0.0;
        
        revenueMap[monthYear] = (revenueMap[monthYear] ?? 0.0) + revenue;
      } catch (e) {
        print('Error processing sale date: ${sale['time']}');
      }
    }
    
    return revenueMap;
  }

  // Method untuk search sales
  void searchSales(String query) {
    if (query.isEmpty) {
      applyFilter();
      return;
    }

    isLoading.value = true;
    
    try {
      filteredSalesHistory.value = salesHistory.where((sale) {
        final customer = sale['customer']?.toString().toLowerCase() ?? '';
        final paymentMethod = sale['payment_method']?.toString().toLowerCase() ?? '';
        final items = sale['items'] as List? ?? [];
        
        // Search in customer name
        if (customer.contains(query.toLowerCase())) return true;
        
        // Search in payment method
        if (paymentMethod.contains(query.toLowerCase())) return true;
        
        // Search in items
        for (var item in items) {
          final itemName = item['name']?.toString().toLowerCase() ?? '';
          if (itemName.contains(query.toLowerCase())) return true;
        }
        
        return false;
      }).toList();
    } catch (e) {
      print('Error searching sales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
