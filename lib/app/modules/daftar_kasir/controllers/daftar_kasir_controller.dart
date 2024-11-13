import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DaftarKasirController extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;
  var tiketList = <Map<String, dynamic>>[].obs;
  var pesananList = <Map<String, dynamic>>[].obs;
  var pesananCount = 0.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  final String baseUrl = 'http://10.0.2.2:8000/api';

  // Add filtered getters
  List<Map<String, dynamic>> get filteredProdukList {
    if (searchQuery.isEmpty) return produkList;
    return produkList.where((item) {
      final namaProduk = item['namaProduk']?.toString().toLowerCase() ?? '';
      return namaProduk.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get filteredTiketList {
    if (searchQuery.isEmpty) return tiketList;
    return tiketList.where((item) {
      final namaTiket = item['namaTiket']?.toString().toLowerCase() ?? '';
      return namaTiket.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProdukList();
    fetchTiketList();
  }

  Future<void> fetchProdukList() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        produkList.value = List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTiketList() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tikets'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        tiketList.value = List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load tickets: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tickets: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }

  void addToPesanan(Map<String, dynamic> item) {
    var existingItem = pesananList.firstWhereOrNull((pesanan) =>
    pesanan['id'] == item['id'] &&
        pesanan['type'] ==
            (item.containsKey('namaProduk') ? 'produk' : 'tiket'));

    if (existingItem != null) {
      existingItem['quantity'] = (existingItem['quantity'] ?? 1) + 1;
      pesananList.refresh();
    } else {
      pesananList.add({
        'id': item['id'],
        'name': item['namaProduk'] ?? item['namaTiket'],
        'price': double.parse(item['hargaJual'].toString()),
        'quantity': 1,
        'type': item.containsKey('namaProduk') ? 'produk' : 'tiket',
        'image': item['image'],
      });
    }

    pesananCount.value = pesananList.length;
    Get.snackbar(
      'Added to Cart',
      '${item['namaProduk'] ?? item['namaTiket']} added to cart',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void removeFromPesanan(Map<String, dynamic> item) {
    pesananList.removeWhere((pesanan) =>
    pesanan['id'] == item['id'] && pesanan['type'] == item['type']);
    pesananCount.value = pesananList.length;
    Get.snackbar(
      'Removed from Cart',
      '${item['name']} removed from cart',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < pesananList.length) {
      if (newQuantity <= 0) {
        removeFromPesanan(pesananList[index]);
      } else {
        pesananList[index]['quantity'] = newQuantity;
        pesananList.refresh();
      }
    }
  }

  void clearPesanan() {
    pesananList.clear();
    pesananCount.value = 0;
  }
}