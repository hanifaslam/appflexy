import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

class ManajemenTiketController extends GetxController {
  RxList tiketList = [].obs;
  RxList filteredTiketList = [].obs;
  final box = GetStorage();
  Timer? _refreshTimer;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTikets();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchTikets() async {
    isLoading.value = true;
    final url = Uri.parse(ApiConstants.getFullUrl(ApiConstants.tikets));
    final token = box.read('token');
    final userId = box.read('user_id');

    if (token == null || userId == null) {
      isLoading.value = false;
      throw Exception('Authentication required');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List) {
          final List<dynamic> allTikets = responseData;
          final userTikets = allTikets
              .where(
                  (tiket) => tiket['user_id'].toString() == userId.toString())
              .toList();
          tiketList.value = userTikets;
          filteredTiketList.value = userTikets;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load tickets: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat tiket: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      filteredTiketList.value = tiketList;
    } else {
      filteredTiketList.value = tiketList.where((tiket) {
        final namaTiket = tiket['namaTiket'].toString().toLowerCase();
        return namaTiket.contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<bool> deleteTiket(int tiketId) async {
    try {
      isLoading.value = true;
      
      print('Deleting tiket with ID: $tiketId');
      
      final token = box.read('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.delete(
        Uri.parse(ApiConstants.getFullUrl('${ApiConstants.tikets}/$tiketId')),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Hapus dari list lokal
        tiketList.removeWhere((tiket) => tiket['id'] == tiketId);
        filteredTiketList.removeWhere((tiket) => tiket['id'] == tiketId);
        
        // Refresh list untuk memastikan data terbaru
        await fetchTikets();
        
        // Show success message
        Get.snackbar(
          'Berhasil',
          'Tiket berhasil dihapus!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
        );
        
        return true;
      } else {
        throw Exception('Failed to delete ticket: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error deleting tiket: $e');
      Get.snackbar(
        'Error', 
        'Gagal menghapus tiket: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTiket(int id, Map<String, dynamic> tiketData) async {
    try {
      isLoading.value = true;
      
      final userId = box.read('user_id');
      final token = box.read('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final dataToUpdate = {
        'id': id,
        'user_id': userId,
        ...tiketData,
      };

      final response = await http.put(
        Uri.parse(ApiConstants.getFullUrl('${ApiConstants.tikets}/$id')),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(dataToUpdate),
      );

      if (response.statusCode == 200) {
        // Refresh data untuk memastikan konsistensi
        await fetchTikets();
        
        Get.snackbar(
          'Berhasil', 
          'Tiket berhasil diperbarui!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        throw Exception('Failed to update ticket: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error updating tiket: $e');
      Get.snackbar(
        'Error', 
        'Gagal mengupdate tiket: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  void sortTikets(bool ascending) {
    if (ascending) {
      filteredTiketList
          .sort((a, b) => a['namaTiket'].compareTo(b['namaTiket']));
    } else {
      filteredTiketList
          .sort((a, b) => b['namaTiket'].compareTo(a['namaTiket']));
    }
  }

  // Method untuk refresh manual
  Future<void> refreshData() async {
    await fetchTikets();
  }
}
