import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarProdukController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        products.value = data.map((item) {
          return {
            'id': item['id'],
            'namaProduk': item['namaProduk'],
            'stok': item['stok'],
            'hargaJual': item['hargaJual'],
            'image': item['image'],
          };
        }).toList();
      } else {
        Get.snackbar(
            'Error', 'Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching products: $e');
    }
  }

  void addProduct(Map<String, dynamic> product) {
    products.add(product); // Add to the local list
  }

  Future<bool> updateProduct(
      int productId, Map<String, dynamic> updatedProduct) async {
    final uri = Uri.parse('http://127.0.0.1:8000/api/products/$productId');
    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedProduct),
      );

      if (response.statusCode == 200) {
        // Update local data if successful
        final index = products.indexWhere((item) => item['id'] == productId);
        if (index != -1) {
          products[index] = updatedProduct; // Update local product
          products.refresh();
        }
        return true;
      } else {
        Get.snackbar(
            'Error', 'Failed to update product: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating product: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    final uri = Uri.parse('http://127.0.0.1:8000/api/products/$productId');
    try {
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        // Remove from local list if deletion was successful
        products.removeWhere((item) => item['id'] == productId);
        return true;
      } else {
        Get.snackbar(
            'Error', 'Failed to delete product: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting product: $e');
      return false;
    }
  }
}
