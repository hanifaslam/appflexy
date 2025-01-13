import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class DaftarKasirController extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;
  var tiketList = <Map<String, dynamic>>[].obs;
  var pesananList = <Map<String, dynamic>>[].obs;
  var pesananCount = 0.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var selectedItems = <int>[].obs;

  final String baseUrl = 'https://cheerful-distinct-fox.ngrok-free.app/api';
  final box = GetStorage(); // GetStorage instance

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

  Future<List<dynamic>> getOrderItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/order_items'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load order items');
      }
    } catch (e) {
      print('Error fetching order items: $e');
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProdukList();
    fetchTiketList();
    syncSelectedItems();
  }

  @override
  void onClose() {
    super.onClose();
    clearPesananCount();
  }

  Future<void> fetchProdukList() async {
    await _fetchList('products', produkList);
  }

  Future<void> fetchTiketList() async {
    await _fetchList('tikets', tiketList);
  }

  Future<void> _fetchList(
      String endpoint, RxList<Map<String, dynamic>> list) async {
    isLoading.value = true;
    try {
      final userId = box.read('user_id'); // Get user_id from storage
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        list.value = List<Map<String, dynamic>>.from(data)
            .where((item) => item['user_id'].toString() == userId.toString())
            .toList();
      } else {
        throw Exception('Failed to load $endpoint: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load $endpoint: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearPesanan() {
    pesananList.clear();
    selectedItems.clear();
    pesananCount.value = 0;
  }

  void clearPesananCount() {
    pesananCount.value = 0;
  }

  // Add clearData method
  void clearData() {
    produkList.clear();
    tiketList.clear();
    pesananList.clear();
    pesananCount.value = 0;
    searchQuery.value = '';
    isLoading.value = false;
    selectedItems.clear();
  }

  // Add refreshData method
  void refreshData() {
    fetchProdukList();
    fetchTiketList();
  }

  void onItemTap(Map<String, dynamic> item) {
    // Handle item tap action
    print('Item tapped: $item');
  }

  void addToCart(Map<String, dynamic> item) {
    final itemId = item['id'];
    final isProduct = item.containsKey('namaProduk');
    final itemName = isProduct ? item['namaProduk'] : item['namaTiket'];

    if (selectedItems.contains(itemId)) {
      Get.snackbar(
        'Item Sudah Ada',
        '$itemName sudah ada dalam keranjang',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    } else {
      final cartItem = {
        ...item,
        'quantity': 1,
        'type': isProduct ? 'product' : 'ticket'
      };

      pesananList.add(cartItem);
      selectedItems.add(itemId);
      updatePesananCount();

      Get.snackbar(
        'Berhasil',
        '$itemName ditambahkan ke keranjang',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
    update();
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < pesananList.length) {
      pesananList[index]['quantity'] = newQuantity;
      updatePesananCount();
    }
  }

  void removeFromPesanan(Map<String, dynamic> item) {
    pesananList.remove(item);
    selectedItems.remove(item['id']);
    updatePesananCount();
    update(); // Memperbarui UI setelah perubahan data
  }

  void removeFromCart(Map<String, dynamic> item) {
    pesananList.remove(item);
    selectedItems.remove(item['id']);
    updatePesananCount();
    update(); // Memperbarui UI setelah perubahan data
  }

  void syncSelectedItems() {
    selectedItems.clear();
    for (var item in pesananList) {
      selectedItems.add(item['id']); // Menyinkronkan ID yang ada di pesanan
    }
    update(); // Memperbarui UI
  }

  void updatePesananCount() {
    pesananCount.value = pesananList.length;
  }

  String getToken() {
    return box.read('token') ?? '';
  }
}
