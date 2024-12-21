import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SalesHistoryController extends GetxController {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  RxList<Map<String, dynamic>> salesHistory = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredSalesHistory =
      <Map<String, dynamic>>[].obs;
  RxString filterType = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSalesHistory();
    //addDummyData();
  }

  // Method to fetch sales history from API
  Future<void> fetchSalesHistory() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/orders'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        salesHistory.value =
            data.map((item) => item as Map<String, dynamic>).toList();
        applyFilter();
      } else {
        throw Exception('Failed to load sales history');
      }
    } catch (e) {
      print('Error fetching sales history: $e');
    }
  }

  // Method to add a sale to the history
  void addSale(Map<String, dynamic> saleData) {
    salesHistory.add(saleData);
    applyFilter();
  }

  String formatCurrency(dynamic value) {
    double doubleValue =
        value is String ? double.tryParse(value) ?? 0.0 : value.toDouble();
    return currencyFormat.format(doubleValue);
  }

  // Method to load all sales data
  List<Map<String, dynamic>> get allSales => salesHistory;

  // Method to apply filter
  void applyFilter() {
    DateTime now = DateTime.now();
    filteredSalesHistory.value = salesHistory.where((sale) {
      DateTime saleDate = DateTime.parse(sale['time']);
      if (filterType.value == 'Mingguan') {
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        return saleDate.isAfter(startOfWeek) &&
            saleDate.isBefore(endOfWeek.add(Duration(days: 1)));
      } else if (filterType.value == 'Bulanan') {
        return saleDate.month == now.month && saleDate.year == now.year;
      } else if (filterType.value == 'Tahunan') {
        return saleDate.year == now.year;
      } else {
        return true;
      }
    }).toList();
  }

  void setFilter(String type) {
    filterType.value = type;
    applyFilter();
  }

// Method to add dummy data
// void addDummyData() {
//   DateTime now = DateTime.now();
//   salesHistory.addAll([
//     {
//       'customer': 'Customer Mingguan',
//       'time': now.subtract(Duration(days: 3)).toIso8601String(),
//       'payment_method': 'Cash',
//       'total': 100000,
//       'items': [
//         {'name': 'Item 1', 'quantity': 1, 'total_item_price': 100000}
//       ]
//     },
//     {
//       'customer': 'Customer Monthly',
//       'time': now.subtract(Duration(days: 15)).toIso8601String(),
//       'payment_method': 'Credit Card',
//       'total': 200000,
//       'items': [
//         {'name': 'Item 2', 'quantity': 2, 'total_item_price': 100000}
//       ]
//     },
//     {
//       'customer': 'Customer Yearly',
//       'time': now.subtract(Duration(days: 200)).toIso8601String(),
//       'payment_method': 'Debit Card',
//       'total': 300000,
//       'items': [
//         {'name': 'Item 3', 'quantity': 3, 'total_item_price': 100000}
//       ]
//     },
//   ]);
//   applyFilter();
// }
}
