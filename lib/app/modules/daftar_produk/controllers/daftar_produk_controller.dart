import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class DaftarProdukController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var filteredProdukList = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;
  final box = GetStorage(); // GetStorage instance

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
  }

  // Method to fetch products from the API
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final userId = box.read('user_id'); // Get user_id from storage
      final response = await http.get(
        Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/products'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> productList = json.decode(response.body);
        products.value = List<Map<String, dynamic>>.from(productList)
            .where(
                (product) => product['user_id'].toString() == userId.toString())
            .toList();
        filteredProdukList.value = products;
        print('Fetched ${products.length} products');
      } else {
        print('Error status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        Get.snackbar(
            'Error', 'Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during fetch: $e');
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to add a new product
  Future<void> addProduct(Map<String, dynamic> newProduct,
      {String? imagePath}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://cheerful-distinct-fox.ngrok-free.app/api/products'),
      );

      final userId = box.read('user_id'); // Get user_id from storage
      request.fields['user_id'] =
          userId.toString(); // Include user_id in the product data

      // Add all product data as fields
      request.fields['namaProduk'] = newProduct['namaProduk'];
      request.fields['kodeProduk'] = newProduct['kodeProduk'];
      request.fields['kategori'] = newProduct['kategori'];
      request.fields['stok'] = newProduct['stok'].toString();
      request.fields['hargaJual'] = newProduct['hargaJual'].toString();
      if (newProduct['keterangan'] != null) {
        request.fields['keterangan'] = newProduct['keterangan'];
      }

      // Add image if provided
      if (imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        var jsonResponse = json.decode(responseData);
        products.add(jsonResponse['data']);
        filteredProdukList.add(jsonResponse['data']);
        Get.snackbar('Success', 'Product added successfully');
      } else {
        print('Error adding product: $responseData');
        Get.snackbar('Error', 'Failed to add product');
      }
    } catch (e) {
      print('Exception adding product: $e');
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  // Method to update a product
  Future<void> updateProduct(int productId, Map<String, dynamic> updatedData,
      {String? imagePath}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://cheerful-distinct-fox.ngrok-free.app/api/products/$productId'),
      );

      final userId = box.read('user_id'); // Get user_id from storage
      request.fields['user_id'] =
          userId.toString(); // Include user_id in the product data

      // Add PUT method simulation
      request.fields['_method'] = 'PUT';

      // Add all product data as fields
      request.fields['namaProduk'] = updatedData['namaProduk'];
      request.fields['kodeProduk'] = updatedData['kodeProduk'];
      request.fields['kategori'] = updatedData['kategori'];
      request.fields['stok'] = updatedData['stok'].toString();
      request.fields['hargaJual'] = updatedData['hargaJual'].toString();
      if (updatedData['keterangan'] != null) {
        request.fields['keterangan'] = updatedData['keterangan'];
      }

      // Add image if provided
      if (imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData);
        int index =
            products.indexWhere((product) => product['id'] == productId);
        if (index != -1) {
          products[index] = jsonResponse['data'];
          filteredProdukList[index] = jsonResponse['data'];
        }
        Get.snackbar('Success', 'Product updated successfully');
      } else {
        print('Error updating product: $responseData');
        Get.snackbar('Error', 'Failed to update product');
      }
    } catch (e) {
      print('Exception updating product: $e');
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  // Method to delete a product
  Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://cheerful-distinct-fox.ngrok-free.app/api/products/$productId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        products.removeWhere((product) => product['id'] == productId);
        filteredProdukList.removeWhere((product) => product['id'] == productId);
        Get.snackbar('Success', 'Product deleted successfully');
      } else {
        print('Error deleting product: ${response.body}');
        Get.snackbar('Error', 'Failed to delete product');
      }
    } catch (e) {
      print('Exception deleting product: $e');
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  // Method to update search query and filter products
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filteredProdukList.value = products
        .where((produk) => produk['namaProduk']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  // Method to sort products
  void sortFilteredProdukList({bool ascending = true}) {
    filteredProdukList.sort((a, b) {
      return ascending
          ? a['namaProduk'].toString().compareTo(b['namaProduk'].toString())
          : b['namaProduk'].toString().compareTo(a['namaProduk'].toString());
    });
  }
}
