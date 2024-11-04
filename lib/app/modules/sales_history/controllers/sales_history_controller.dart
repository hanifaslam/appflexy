import 'package:get/get.dart';
import 'package:apptiket/app/modules/pembayaran_cash/controllers/pembayaran_cash_controller.dart';

class SalesHistoryController extends GetxController {
  // Observable list to store sales data
  RxList<Map<String, dynamic>> salesData = <Map<String, dynamic>>[].obs;

  // Instance of PembayaranCashController to access orders
  final PembayaranCashController pembayaranController = Get.find();

  // Method to load sales data from pesananList
  void loadSalesData() {
    // Clear existing data
    salesData.clear();

    // Load data from pembayaranController.pesananList
    for (var item in pembayaranController.pesananList) {
      salesData.add({
        'customer': item['customer'] ??
            'Unknown Customer', // Dynamic customer name if available
        'time': item['time'] ??
            DateTime.now().toString(), // Dynamic sale time if available
        'paymentMethod': item['paymentMethod'] ??
            'Unknown Method', // Payment method from the item
        'paymentSource': item['paymentSource'] ??
            'Unknown Source', // Payment source from the item
        'items':
            item['items'] ?? [], // Include item details; ensure this key exists
        'total': item['total'] ?? 0, // Adjusted to access total from item
      });
    }
  }

  // Method to format currency using PembayaranCashController
  String formatCurrency(double amount) {
    return pembayaranController.formatCurrency(amount);
  }
}
