import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For API requests
import 'package:intl/intl.dart'; // For date formatting

class HomeController extends GetxController {
  var isLoading = false.obs;
  var barChartData = <BarChartGroupData>[].obs;
  var monthLabels = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBarChartData();
  }

  // Function to fetch data from the API
  Future<void> fetchBarChartData() async {
    isLoading.value = true;
    final url = Uri.parse('http://10.0.2.2:8000/api/orders');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        processChartData(data);
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to process and format data for the chart
  void processChartData(List<dynamic> data) {
    barChartData.clear(); // Clear previous data
    monthLabels.clear(); // Clear previous labels

    // Define the fixed x-axis labels
    List<String> fixedLabels = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"];
    Map<int, double> monthlyTotals = {};

    // Get the current year
    int currentYear = DateTime.now().year;

    for (var order in data) {
      DateTime date = DateTime.parse(order['created_at']);
      if (date.year == currentYear) {
        int month = date.month;
        double total = double.parse(order['total'].toString()); // Parse the total to double

        monthlyTotals.update(month, (sum) => sum + total, ifAbsent: () => total);
      }
    }

    for (int i = 1; i <= 12; i++) {
      double total = monthlyTotals[i] ?? 0.0;
      barChartData.add(
        BarChartGroupData(
          x: i - 1,
          barRods: [
            BarChartRodData(
              toY: total,
              color: Colors.blueAccent,
              width: 15,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
      monthLabels.add(fixedLabels[i - 1]);
    }
  }
}