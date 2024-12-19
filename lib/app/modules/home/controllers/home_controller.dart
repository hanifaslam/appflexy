import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API requests

class HomeController extends GetxController {
  var isLoading = false.obs;
  var pieChartData = <PieChartSectionData>[].obs;
  var totalOrders = 0.obs;
  var selectedFilter = 'Harian'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPieChartData(selectedFilter.value);
  }

  // Function to fetch data from the API
  Future<void> fetchPieChartData(String filter) async {
    isLoading.value = true;
    final url = Uri.parse('http://10.0.2.2:8000/api/orders?filter=$filter');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched data: $data'); // Log fetched data
        processPieChartData(data);
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to process and format data for the pie chart
  void processPieChartData(List<dynamic> data) {
    pieChartData.clear(); // Clear previous data
    totalOrders.value = 0; // Reset total orders

    Map<String, double> orderCounts = {};

    for (var order in data) {
      var orderItems = order['items'] as List<dynamic>?;
      if (orderItems != null) {
        for (var item in orderItems) {
          String? itemName = item['name'];
          double? itemPrice = item['total_item_price'] != null ? double.tryParse(item['total_item_price'].toString()) : null;

          if (itemName != null && itemPrice != null) {
            orderCounts.update(itemName, (sum) => sum + itemPrice, ifAbsent: () => itemPrice);
            totalOrders.value += itemPrice.toInt();
          }
        }
      }
    }

    double total = totalOrders.value.toDouble();
    print('Processed order counts: $orderCounts'); // Log processed order counts
    print('Total orders: $totalOrders'); // Log total orders

    pieChartData.addAll(orderCounts.entries.map((entry) {
      return PieChartSectionData(
        color: Colors.primaries[orderCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        value: (entry.value / total) * 100,
        title: '${(entry.value / total * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList());
    print('Pie chart data: $pieChartData'); // Log pie chart data
  }
}