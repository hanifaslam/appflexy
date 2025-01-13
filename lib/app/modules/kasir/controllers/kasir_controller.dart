import 'dart:convert';
import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../widgets/pdfpreview_page.dart';

class ApiEndpoints {
  static const String baseUrl =
      'https://cheerful-distinct-fox.ngrok-free.app'; // Replace with your actual base URL
}

class KasirController extends GetxController {
  final DaftarKasirController daftarKasirController =
      Get.find<DaftarKasirController>();
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  var isProcessing = false.obs;
  RxList<RxInt> localQuantities = <RxInt>[].obs;
  var selectedPaymentMethod = ''.obs;
  var _total = 0.0.obs;

  set total(double value) => _total.value = value;
  double get totalValue => _total.value;

  @override
  void onInit() {
    super.onInit();
    initializeLocalQuantities();
  }

  void initializeLocalQuantities() {
    if (daftarKasirController.pesananList.isEmpty) {
      localQuantities.clear();
      return;
    }
    localQuantities.value = List.generate(
      daftarKasirController.pesananList.length,
      (index) =>
          RxInt(daftarKasirController.pesananList[index]['quantity'] ?? 1),
    );
  }

  List<Map<String, dynamic>> get pesananList =>
      daftarKasirController.pesananList;

  double get total => pesananList.asMap().entries.fold(0.0, (sum, entry) {
        final index = entry.key;
        final item = entry.value;
        final price = double.tryParse(item['hargaJual'].toString()) ?? 0.0;
        final quantity =
            localQuantities.isNotEmpty ? localQuantities[index].value : 1;
        return sum + (price * quantity);
      });

  Future<bool> submitOrder() async {
    try {
      isProcessing.value = true;
      final userId = await getUserId();

      // Debug statement to verify user ID retrieval
      print('User ID: $userId');

      if (userId.isEmpty) {
        Get.offAllNamed('/login'); // Redirect to login
        return false;
      }

      // Format items according to backend schema
      final items = pesananList.map((item) {
        final index = pesananList.indexOf(item);
        return {
          'id': item['id'],
          'name': item['type'] == 'product'
              ? item['namaProduk']
              : item['namaTiket'],
          'quantity': localQuantities[index].value,
          'price': double.parse(item['hargaJual'].toString()),
          'total_item_price': double.parse(item['hargaJual'].toString()) *
              localQuantities[index].value,
          'type': item['type']
        };
      }).toList();

      final orderData = {
        'user_id': userId,
        'customer': '', // Optional customer name
        'time': DateTime.now().toIso8601String(),
        'payment_method': selectedPaymentMethod.value,
        'total': _total.value,
        'items': items
      };

      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Order created: ${responseData['message']}');
        return true;
      } else {
        print('Failed: ${response.statusCode} - ${response.body}');
        Get.snackbar('Error', 'Failed to create order');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Failed to process order: $e');
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<String> getUserId() async {
    final box = GetStorage();
    final userId = box.read('user_id')?.toString() ?? '';
    print('Retrieved User ID: $userId'); // Debug statement
    return userId;
  }

  void _recalculateTotal() {
    double newTotal = 0.0;
    for (int i = 0; i < pesananList.length; i++) {
      final price =
          double.tryParse(pesananList[i]['hargaJual'].toString()) ?? 0.0;
      final quantity = localQuantities[i].value;
      newTotal += price * quantity;
    }
    _total.value = newTotal;
    update();
  }

  void updateQuantity(int index, int delta) {
    if (index < localQuantities.length) {
      final newValue = localQuantities[index].value + delta;
      if (newValue >= 1) {
        localQuantities[index].value = newValue;
        _recalculateTotal();
        update();
      }
    }
  }

  void removeItem(int index) {
    if (index < pesananList.length && index < localQuantities.length) {
      try {
        // Remove from pesananList first
        daftarKasirController.pesananList.removeAt(index);

        // Remove from localQuantities
        localQuantities.removeAt(index);

        // Update DaftarKasirController state
        daftarKasirController.updatePesananCount();

        // Recalculate total
        _recalculateTotal();

        // If list is empty, clear everything
        if (daftarKasirController.pesananList.isEmpty) {
          localQuantities.clear();
          _total.value = 0.0;
        }

        // Notify UI to update
        update();
      } catch (e) {
        print('Error removing item: $e');
      }
    }
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    update();
  }

  void clearOrder() {
    daftarKasirController.clearPesanan();
    localQuantities.clear();
    selectedPaymentMethod.value = '';
    _total.value = 0.0;
    update();
  }

  Icon getQuantityIcon(int index) {
    return Icon(
      localQuantities[index].value > 1 ? Icons.remove : Icons.delete_outlined,
      size: 18,
      color: Colors.grey[600],
    );
  }

  String formatCurrency(double value) => currencyFormat.format(value);

  // Method to handle errors
  void handleError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Method to validate order before submission
  bool validateOrder() {
    if (pesananList.isEmpty) {
      handleError('Tidak ada item dalam pesanan');
      return false;
    }

    if (selectedPaymentMethod.value.isEmpty) {
      handleError('Silakan pilih metode pembayaran');
      return false;
    }

    if (total <= 0) {
      handleError('Total pesanan tidak valid');
      return false;
    }

    return true;
  }

  List<OrderItem> getOrderItems() {
    return pesananList.map((item) {
      final index = pesananList.indexOf(item);
      return OrderItem(
        name: item['type'] == 'product' ? item['namaProduk'] : item['namaTiket'],
        quantity: localQuantities[index].value,
        price: double.tryParse(item['hargaJual'].toString()) ?? 0.0,
      );
    }).toList();
  }

}
