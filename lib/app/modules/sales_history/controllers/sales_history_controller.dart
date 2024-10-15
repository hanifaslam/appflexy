import 'package:get/get.dart';

class SalesHistoryController extends GetxController {
  // Data penjualan yang pake Rx untuk bisa di-reload secara reactive
  var salesData = [
    {
      'customer': 'Customer 10',
      'time': '21/09/2024 - 10:23 AM',
      'paymentSource': 'Ambatron',
      'paymentMethod': 'QRIS',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 2, 'price': 50000},
        {'name': 'Tiket Anak', 'quantity': 1, 'price': 35000},
        {'name': 'Jaket Pelampung', 'quantity': 1, 'price': 20000},
      ],
      'memberDiscount': 20000,
      'total': 135000
    },
    {
      'customer': 'Customer 9',
      'time': '21/09/2024 - 10:20 AM',
      'paymentSource': 'Bagas Kopling',
      'paymentMethod': 'Debit',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 2, 'price': 50000},
        {'name': 'Tiket Anak', 'quantity': 1, 'price': 35000},
      ],
      'memberDiscount': 10000,
      'total': 125000
    },
    // Tambahin data lainnya 
  ].obs; // Menggunakan "obs" agar bisa reaktif.

  // Fungsi format currency
  String formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
  }
}