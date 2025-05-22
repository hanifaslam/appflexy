import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
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

  Future<void> deleteTiket(int tiketId) async {
    try {      final response = await http.delete(
        Uri.parse(ApiConstants.getFullUrl('${ApiConstants.tikets}/$tiketId')),
        headers: {
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        tiketList.removeWhere((tiket) => tiket['id'] == tiketId);
        filteredTiketList.value = List.from(tiketList);
        Get.snackbar('Sukses', 'Tiket berhasil dihapus!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        throw Exception('Failed to delete ticket: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus tiket: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateTiket(int id, Map<String, dynamic> tiketData) async {
    try {
      final userId = box.read('user_id');

      final dataToUpdate = {
        'id': id,
        'user_id': userId,
        ...tiketData,
      };      final response = await http.put(
        Uri.parse(ApiConstants.getFullUrl('${ApiConstants.tikets}/$id')),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: json.encode(dataToUpdate),
      );

      if (response.statusCode == 200) {
        final index = tiketList.indexWhere((tiket) => tiket['id'] == id);
        if (index != -1) {
          tiketList[index] = dataToUpdate;
          filteredTiketList.value = List.from(tiketList);
        }
        Get.snackbar('Sukses', 'Tiket berhasil diperbarui!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        throw Exception('Failed to update ticket: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengupdate tiket: $e',
          snackPosition: SnackPosition.BOTTOM);
      throw e;
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
}
