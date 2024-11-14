import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesHistoryController extends GetxController {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  RxList<Map<String, dynamic>> salesHistory = <Map<String, dynamic>>[].obs;

  // Method to add a sale to the history
  void addSale(Map<String, dynamic> saleData) {
    salesHistory.add(saleData);
  }

  String formatCurrency(double value) {
    return currencyFormat.format(value);
  }

  // Method to load all sales data
  List<Map<String, dynamic>> get allSales => salesHistory;
}
