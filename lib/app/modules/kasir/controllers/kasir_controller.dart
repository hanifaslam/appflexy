import 'dart:convert';
import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  @override
  void onInit() {
    super.onInit();
    initializeLocalQuantities();
  }

  void initializeLocalQuantities() {
    localQuantities.value = List.generate(
      daftarKasirController.pesananList.length,
          (index) =>
          RxInt(daftarKasirController.pesananList[index]['quantity'] ?? 1),
    );
  }

  List<Map<String, dynamic>> get pesananList =>
      daftarKasirController.pesananList;

  double get total => pesananList.fold(0.0, (sum, item) {
    final price = double.tryParse(item['price'].toString()) ?? 0.0;
    final quantity = localQuantities.isNotEmpty
        ? localQuantities[pesananList.indexOf(item)].value
        : 1;
    return sum + (price * quantity);
  });

  Future<bool> submitOrder() async {
    print('submitOrder function called');

    // Validasi sebelum mengirim
    if (pesananList.isEmpty) {
      print('Pesanan list kosong');
      Get.snackbar(
        'Error',
        'No items in order',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedPaymentMethod.value.isEmpty) {
      print('Payment method belum dipilih');
      Get.snackbar(
        'Error',
        'Please select a payment method',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (isProcessing.value) {
      print('Masih dalam proses');
      return false;
    }

    isProcessing.value = true;

    try {
      final orderData = {
        'customer': 'Walk-in Customer',
        'time': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'payment_method': selectedPaymentMethod.value,
        'total': total,
        'items': pesananList.map((item) {
          final index = pesananList.indexOf(item);
          final quantity = localQuantities[index].value;
          return {
            'name': item['name'],
            'quantity': quantity,
            'price': item['price'],
            'total_item_price': item['price'] * quantity,
          };
        }).toList(),
      };

      print('Order Data: ${jsonEncode(orderData)}');
      print('Sending to URL: ${daftarKasirController.baseUrl}/orders');

      final response = await http.post(
        Uri.parse('${daftarKasirController.baseUrl}/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {

        Get.snackbar(
          'Success',
          'Order has been processed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        throw Exception(
            'Failed to create order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error submitting order: $e');
      Get.snackbar(
        'Error',
        'Failed to process order: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  void updateQuantity(int index, int change) {
    if (index >= 0 && index < localQuantities.length) {
      final newQuantity = localQuantities[index].value + change;
      if (newQuantity > 0) {
        localQuantities[index].value = newQuantity;
        daftarKasirController.updateQuantity(index, newQuantity);
      } else {
        daftarKasirController.removeFromPesanan(pesananList[index]);
        localQuantities.removeAt(index);
      }
    }
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void clearOrder() {
    daftarKasirController.clearPesanan();
    localQuantities.clear();
    selectedPaymentMethod.value = '';
  }

  String formatCurrency(double value) => currencyFormat.format(value);
}
