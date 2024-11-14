import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManajemenTiketController extends GetxController {
  RxList tiketList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTikets(); // Panggil fetchTikets saat controller diinisialisasi
  }

  Future<void> fetchTikets() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/tikets');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        tiketList.value =
            data['tikets']; // Asumsi response memiliki list 'tikets'
      } else {
        print('Failed to load tickets');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
