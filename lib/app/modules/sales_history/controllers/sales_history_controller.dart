import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SalesHistoryController extends GetxController {
  final box = GetStorage();
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
  String? getToken() => box.read('token');
  int? getUserId() => box.read('user_id');

  Future<void> fetchSalesHistory() async {
    try {
      final token = getToken();
      final userId = getUserId();

      print('Fetching sales history');
      print('Token: $token');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse(
            'https://cheerful-distinct-fox.ngrok-free.app/api/orders?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        salesHistory.value = data
            .where((order) => order['user_id'] == userId)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        filteredSalesHistory.value = List.from(salesHistory);
        applyFilter();
      }
    } catch (e) {
      print('Error fetching sales history: $e');
      Get.snackbar('Error', 'Failed to load sales history');
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
}
