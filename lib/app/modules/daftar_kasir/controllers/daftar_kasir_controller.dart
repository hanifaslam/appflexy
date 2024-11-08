import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DaftarKasirController extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;
  var tiketList = <Map<String, dynamic>>[].obs;
  var pesananList = <Map<String, dynamic>>[].obs; // Observable list
  var pesananCount = 0.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProdukList();
    fetchTiketList();
  }

  // Fetch products from API
  Future<void> fetchProdukList() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        produkList.value = List<Map<String, dynamic>>.from(data);
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products: $e');
    }
  }

  // Fetch tickets from API
  Future<void> fetchTiketList() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/tikets'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        tiketList.value = List<Map<String, dynamic>>.from(data);
      } else {
        Get.snackbar('Error', 'Failed to load tickets');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tickets: $e');
    }
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }

  // Filtered list based on search query for products
  List<Map<String, dynamic>> get filteredProdukList {
    if (searchQuery.isEmpty) return produkList;
    return produkList.where((item) => (item['namaProduk']?.toString().toLowerCase() ?? '').contains(searchQuery.value)).toList();
  }

  // Filtered list based on search query for tickets
  List<Map<String, dynamic>> get filteredTiketList {
    if (searchQuery.isEmpty) return tiketList;
    return tiketList.where((item) => (item['namaTiket']?.toString().toLowerCase() ?? '').contains(searchQuery.value)).toList();
  }

  // Add an item to pesananList and update pesananCount
  void addToPesanan(Map<String, dynamic> item) {
    // Check if the item is already in pesananList
    var existingItem = pesananList.firstWhereOrNull((pesanan) => pesanan['id'] == item['id']);
    if (existingItem != null) {
      // If it exists, increase the quantity
      existingItem['quantity']++;
    } else {
      // If it doesn't exist, add it to the list
      pesananList.add({
        'id': item['id'],
        'name': item['namaProduk'] ?? item['namaTiket'],
        'price': item['hargaJual'],
        'quantity': 1,
        'type': item.containsKey('namaProduk') ? 'produk' : 'tiket',
      });
    }
    pesananCount.value = pesananList.length;
    print('Pesanan List: $pesananList');
    Get.snackbar('Pesanan', '${item['namaProduk'] ?? item['namaTiket']} added to pesanan.', colorText: Colors.white);
  }


  // Remove an item from pesananList and update pesananCount
  void removeFromPesanan(Map<String, dynamic> item) {
    pesananList.removeWhere((pesanan) => pesanan['id'] == item['id']);
    pesananCount.value = pesananList.length;

    Get.snackbar('Pesanan', '${item['namaProduk'] ?? item['namaTiket']} removed from pesanan.');
  }

  // Update the quantity of an item in pesananList
  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < pesananList.length) {
      pesananList[index]['quantity'] = quantity;
      if (quantity <= 0) removeFromPesanan(pesananList[index]); // Remove if quantity is zero
    }
  }
}
