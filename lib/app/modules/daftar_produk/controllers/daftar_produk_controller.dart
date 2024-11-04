import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarProdukController extends GetxController {
  var products = <Map<String, dynamic>>[].obs; // List of all products
  var filteredProdukList =
      <Map<String, dynamic>>[].obs; // Filtered product list
  var searchQuery = ''.obs; // Search query
  var isLoading = true.obs; // Loading state

  @override
  void onReady() {
    super.onReady();
    fetchProducts(); // Fetch products when the controller is initialized
  }

  // Method to fetch products from the API
  Future<void> fetchProducts() async {
    isLoading.value = true; // Set loading to true
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/products'));

    if (response.statusCode == 200) {
      List<dynamic> productList = json.decode(response.body);
      products.value = List<Map<String, dynamic>>.from(productList);
      filteredProdukList.value =
          products; // Initially, filtered list is all products
    } else {
      // Handle error
      Get.snackbar('Error', 'Failed to load products');
    }
    isLoading.value = false; // Set loading to false
  }

  // Method to add a new product to the list
  void addProduct(Map<String, dynamic> newProduct) {
    products.add(newProduct); // Add new product to the product list
    filteredProdukList.add(newProduct); // Also add to filtered list
  }

  // Method to delete a product by ID
  Future<void> deleteProduct(int productId) async {
    final response = await http
        .delete(Uri.parse('http://10.0.2.2:8000/api/products/$productId'));

    if (response.statusCode == 200) {
      products.removeWhere((product) =>
          product['id'] == productId); // Remove product from the list
      filteredProdukList.removeWhere(
          (product) => product['id'] == productId); // Remove from filtered list
      Get.snackbar('Success', 'Product deleted successfully');
    } else {
      // Handle error
      Get.snackbar('Error', 'Failed to delete product');
    }
  }

  // Method to refresh the product list
  Future<void> refreshProductList() async {
    await fetchProducts(); // Call fetch to reload data from the API
  }

  // Method to update the search query and filter the product list
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filteredProdukList.value = products
        .where((produk) => produk['namaProduk']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList(); // Filter products based on the search query
  }

  // Method to sort the filtered product list by name
  void sortFilteredProdukList({bool ascending = true}) {
    filteredProdukList.sort((a, b) {
      return ascending
          ? a['namaProduk'].compareTo(b['namaProduk'])
          : b['namaProduk'].compareTo(a['namaProduk']);
    });
  }

  // Method to update a product
  Future<void> updateProduct(
      int productId, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/products/$productId'),
      body: updatedData,
    );

    if (response.statusCode == 200) {
      // Update the local product list
      int index = products.indexWhere((product) => product['id'] == productId);
      if (index != -1) {
        products[index] = updatedData; // Replace with updated data
        filteredProdukList[index] = updatedData; // Also update filtered list
      }
      Get.snackbar('Success', 'Product updated successfully');
    } else {
      // Handle error
      Get.snackbar('Error', 'Failed to update product');
    }
  }
}
