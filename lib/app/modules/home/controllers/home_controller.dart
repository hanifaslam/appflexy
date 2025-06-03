import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final box = GetStorage();
  var isLoading = false.obs;
  var storeData = Rxn<Map<String, dynamic>>();
  final RxList<LineChartPoint> lineChartData = <LineChartPoint>[].obs;
  final RxBool isLoadingLineChart = false.obs;
  final RxString selectedLineChartFilter = 'two_months'.obs;
  
  // Recent transactions properties
  final RxList<Map<String, dynamic>> recentTransactions = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingRecentTransactions = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('HomeController onInit dipanggil');
    fetchCompanyDetails();
    fetchLineChartData(selectedLineChartFilter.value);
    fetchRecentTransactions();
  }

  String? getToken() => box.read('token');
  int? getUserId() => box.read('user_id');

  Future<void> fetchCompanyDetails() async {
    try {
      isLoading(true);
      final token = getToken();
      final userId = getUserId();

      print('User ID yang ada di GetStorage: $userId');
      print('Token: $token');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }
      
      final response = await http.get(
        Uri.parse(ApiConstants.getFullUrl(ApiConstants.stores)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData['data'] != null && responseData['data'].isNotEmpty) {
          final List<dynamic> data = responseData['data'];
          print('Data stores: $data');

          final userStore = data.firstWhere(
            (store) => store['user_id'].toString() == userId.toString(),
            orElse: () {
              print('Store tidak ditemukan untuk user_id: $userId');
              return null;
            },
          );

          if (userStore != null) {
            storeData.value = {
              'nama_usaha': userStore['nama_usaha'] ?? 'Nama tidak ditemukan',
              'gambar': userStore['gambar'] ?? 'kosong',
            };
            print('Store data ditemukan: ${storeData.value}');
          } else {
            storeData.value = {
              'nama_usaha': 'Data tidak ditemukan',
              'gambar': 'kosong',
            };
          }
        } else {
          print('Data toko kosong atau tidak ditemukan');
          storeData.value = {
            'nama_usaha': 'Data tidak ditemukan',
            'gambar': 'default_image_url_or_placeholder',
          };
        }
      } else {
        throw Exception('Failed to fetch store details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching company details: $e');
      Get.snackbar('Error', 'Failed to fetch company details');
    } finally {
      isLoading(false);
    }
  }

  void fetchLineChartData(String filter) async {
    isLoadingLineChart.value = true;
    try {
      final token = getToken();
      final userId = getUserId();

      print('Fetching line chart data with filter: $filter');
      print('Token: $token');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Line chart response status: ${response.statusCode}');
      print('Line chart response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<dynamic> orders = [];

        if (responseData is List) {
          orders = responseData;
        } else if (responseData is Map && responseData['data'] is List) {
          orders = responseData['data'];
        } else {
          print('Unexpected response structure: $responseData');
          lineChartData.clear();
          return;
        }

        final userOrders = orders.where((order) => 
          order['user_id']?.toString() == userId.toString()
        ).toList();

        print('Processing ${userOrders.length} orders for line chart');
        
        if (filter == 'day') {
          _processDataByDay(userOrders);
        } else {
          _processDataByTwoMonths(userOrders);
        }
      } else {
        print('Failed to fetch line chart data: ${response.statusCode}');
        lineChartData.clear();
      }
    } catch (e) {
      lineChartData.clear();
      print('Error fetching line chart data: $e');
      Get.snackbar('Error', 'Failed to load line chart data: $e');
    }
    isLoadingLineChart.value = false;
  }

  // Method to fetch recent transactions (5 latest)
  Future<void> fetchRecentTransactions() async {
    try {
      isLoadingRecentTransactions(true);
      final token = getToken();
      final userId = getUserId();

      print('Fetching recent transactions');
      print('Token: $token');
      print('User ID: $userId');

      if (token == null || userId == null) {
        throw Exception('Authentication required');
      }
      
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/orders?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        // Filter by user_id, sort by time (newest first), and take only 5
        final userTransactions = data
            .where((order) => order['user_id'] == userId)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
            
        // Sort by time (newest first)
        userTransactions.sort((a, b) {
          DateTime timeA = DateTime.parse(a['time']);
          DateTime timeB = DateTime.parse(b['time']);
          return timeB.compareTo(timeA); // newest first
        });
        
        // Take only the 5 most recent transactions
        recentTransactions.value = userTransactions.take(5).toList();
        
        print('Recent transactions loaded: ${recentTransactions.length}');
      } else {
        throw Exception('Failed to fetch recent transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recent transactions: $e');
      Get.snackbar('Error', 'Failed to load recent transactions');
    } finally {
      isLoadingRecentTransactions(false);
    }
  }

  void _processDataByDay(List<dynamic> userOrders) {
    final Map<String, double> grouped = {};
    final now = DateTime.now();
    
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.day}/${date.month}';
      grouped[dateKey] = 0.0;
    }

    for (var order in userOrders) {
      final createdAt = order['created_at'];
      if (createdAt == null) continue;

      try {
        final date = DateTime.parse(createdAt);
        final dateKey = '${date.day}/${date.month}';
        
        if (now.difference(date).inDays <= 30) {
          double total = 0.0;
          if (order['items'] != null && order['items'] is List) {
            for (var item in order['items']) {
              final itemPrice = double.tryParse(item['total_item_price']?.toString() ?? '0') ?? 0.0;
              total += itemPrice;
            }
          } else {
            total = double.tryParse(order['total']?.toString() ?? '0') ?? 0.0;
          }

          grouped[dateKey] = (grouped[dateKey] ?? 0) + total;
        }
      } catch (e) {
        print('Error parsing date for daily chart: $e');
        continue;
      }
    }

    final List<LineChartPoint> points = grouped.entries.map((e) {
      return LineChartPoint(label: e.key, value: e.value);
    }).toList();

    lineChartData.value = points;
    print('Daily chart data points: ${points.length}');
    for (var point in points) {
      print('Daily Point: ${point.label} = ${point.value}');
    }
  }

  void _processDataByTwoMonths(List<dynamic> userOrders) {
    final Map<String, double> grouped = {
      'Januari': 0.0,   // Jan-Feb
      'Maret': 0.0,     // Mar-Apr
      'Mei': 0.0,       // May-Jun
      'Juli': 0.0,      // Jul-Aug
      'September': 0.0, // Sep-Oct
      'November': 0.0,  // Nov-Dec
    };

    for (var order in userOrders) {
      final createdAt = order['created_at'];
      if (createdAt == null) continue;

      try {
        final date = DateTime.parse(createdAt);
        
        String periodLabel;
        
        if (date.month <= 2) {
          periodLabel = 'Januari';
        } else if (date.month <= 4) {
          periodLabel = 'Maret';
        } else if (date.month <= 6) {
          periodLabel = 'Mei';
        } else if (date.month <= 8) {
          periodLabel = 'Juli';
        } else if (date.month <= 10) {
          periodLabel = 'September';
        } else {
          periodLabel = 'November';
        }

        double total = 0.0;
        if (order['items'] != null && order['items'] is List) {
          for (var item in order['items']) {
            final itemPrice = double.tryParse(item['total_item_price']?.toString() ?? '0') ?? 0.0;
            total += itemPrice;
          }
        } else {
          total = double.tryParse(order['total']?.toString() ?? '0') ?? 0.0;
        }

        grouped[periodLabel] = (grouped[periodLabel] ?? 0) + total;
        
      } catch (e) {
        print('Error parsing date for two-month chart: $e');
        continue;
      }
    }

    print('Two-month grouped data: $grouped');

    final List<LineChartPoint> points = [
      LineChartPoint(label: 'Januari', value: grouped['Januari']!),
      LineChartPoint(label: 'Maret', value: grouped['Maret']!),
      LineChartPoint(label: 'Mei', value: grouped['Mei']!),
      LineChartPoint(label: 'Juli', value: grouped['Juli']!),
      LineChartPoint(label: 'September', value: grouped['September']!),
      LineChartPoint(label: 'November', value: grouped['November']!),
    ];

    lineChartData.value = points;
    print('Two-month chart data points: ${points.length}');
    for (var point in points) {
      print('Two-month Point: ${point.label} = ${point.value}');
    }
  }

  // Helper method to format currency
  String formatCurrency(dynamic value) {
    double doubleValue = value is String ? double.tryParse(value) ?? 0.0 : value.toDouble();
    return 'Rp ${doubleValue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  void onClose() {
    print('HomeController ditutup');
    super.onClose();
  }
}

class LineChartPoint {
  final String label;
  final double value;
  
  LineChartPoint({required this.label, required this.value});
  
  factory LineChartPoint.fromJson(Map<String, dynamic> json) => LineChartPoint(
    label: json['label'],
    value: (json['value'] as num).toDouble(),
  );
}