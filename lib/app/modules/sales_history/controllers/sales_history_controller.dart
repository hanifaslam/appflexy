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
      {
      'customer': 'Customer 8',
      'time': '21/09/2024 - 10:16 AM',
      'paymentSource': 'Mas Rusdi',
      'paymentMethod': 'QRIS',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 1, 'price': 50000},
        {'name': 'Jaket Pelampung', 'quantity': 1, 'price': 20000},
      ],
      'memberDiscount': 5000,
      'total': 65000
    },
    {
      'customer': 'Customer 7',
      'time': '21/09/2024 - 10:12 AM',
      'paymentSource': 'Raol',
      'paymentMethod': 'Tunai',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 2, 'price': 50000},
        {'name': 'Tiket Anak', 'quantity': 1, 'price': 35000},
      ],
      'memberDiscount': 20000,
      'total': 115000
    },
    {
      'customer': 'Customer 6',
      'time': '21/09/2024 - 10:08 AM',
      'paymentSource': 'Yanto',
      'paymentMethod': 'QRIS',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 1, 'price': 50000},
        {'name': 'Jaket Pelampung', 'quantity': 1, 'price': 20000},
      ],
      'memberDiscount': 5000,
      'total': 65000
    },
    {
      'customer': 'Customer 5',
      'time': '21/09/2024 - 10:00 AM',
      'paymentSource': 'Mulyo',
      'paymentMethod': 'Tunai',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 1, 'price': 50000},
        {'name': 'Tiket Anak', 'quantity': 1, 'price': 35000},
      ],
      'memberDiscount': 10000,
      'total': 75000
    },
    {
      'customer': 'Customer 4',
      'time': '21/09/2024 - 09:55 AM',
      'paymentSource': 'Jin Kazama',
      'paymentMethod': 'Debit',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 2, 'price': 50000},
        {'name': 'Jaket Pelampung', 'quantity': 1, 'price': 20000},
      ],
      'memberDiscount': 10000,
      'total': 110000
    },
    {
      'customer': 'Customer 3',
      'time': '21/09/2024 - 09:50 AM',
      'paymentSource': 'Steve Fox',
      'paymentMethod': 'Tunai',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 1, 'price': 50000},
        {'name': 'Jaket Pelampung', 'quantity': 1, 'price': 20000},
      ],
      'memberDiscount': 5000,
      'total': 65000
    },
    {
      'customer': 'Customer 2',
      'time': '21/09/2024 - 09:40 AM',
      'paymentSource': 'Lee Chaolan',
      'paymentMethod': 'Tunai',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 1, 'price': 50000},
        {'name': 'Tiket Anak', 'quantity': 1, 'price': 35000},
      ],
      'memberDiscount': 10000,
      'total': 75000
    },
    {
      'customer': 'Customer 1',
      'time': '21/09/2024 - 09:45 AM',
      'paymentSource': 'Kuma',
      'paymentMethod': 'QRIS',
      'items': [
        {'name': 'Tiket Dewasa', 'quantity': 2, 'price': 50000},
        {'name': 'Tiket Anak', 'quantity': 1, 'price': 35000},
        {'name': 'Jaket Pelampung', 'quantity': 1, 'price': 20000},
      ],
      'memberDiscount': 20000,
      'total': 135000
    },
    // Tambahin data lainnya 
  ].obs; // Menggunakan "obs" agar bisa reaktif.

  // Fungsi format currency
  String formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
  }
}