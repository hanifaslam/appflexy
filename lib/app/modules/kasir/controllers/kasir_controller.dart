import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../daftar_kasir/controllers/daftar_kasir_controller.dart';
import '../../sales_history/controllers/sales_history_controller.dart';

class KasirController extends GetxController {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  final DaftarKasirController daftarKasirController = Get.find<DaftarKasirController>();
  final SalesHistoryController salesHistoryController = Get.put(SalesHistoryController());

  RxList<RxInt> localQuantities = <RxInt>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeLocalQuantities();
  }

  void initializeLocalQuantities() {
    localQuantities.value = List.generate(
      daftarKasirController.pesananList.length,
          (index) => RxInt(daftarKasirController.pesananList[index]['quantity'] ?? 1),
    );
  }

  List<Map<String, dynamic>> get pesananList => daftarKasirController.pesananList;

  double get total => pesananList.fold(0.0, (sum, item) {
    final price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    int quantity = localQuantities.isNotEmpty ? localQuantities[pesananList.indexOf(item)].value : 1;
    return sum + (price * quantity);
  });

  void updateQuantity(int index, int change) {
    if (index >= 0 && index < localQuantities.length) {
      int currentQuantity = localQuantities[index].value;
      int newQuantity = currentQuantity + change;
      localQuantities[index].value = newQuantity > 0 ? newQuantity : 0;
    }
  }

  String formatCurrency(double value) {
    return currencyFormat.format(value);
  }

  void clearPesanan() {
    daftarKasirController.pesananList.clear();
    localQuantities.clear();
  }

  // New method to prepare and save sales history
  void saveOrderHistory() {
    final salesData = {
      'customer': 'Customer Name', // Replace with actual customer data if available
      'time': DateTime.now().toString(),
      'paymentMethod': pesananList.isNotEmpty ? pesananList.first['selectedPaymentMethod'] : 'Unknown Method',
      'items': pesananList.map((item) {
        final int index = pesananList.indexOf(item);
        final int quantity = localQuantities[index].value;
        return {
          'name': item['name'],
          'quantity': quantity,
          'hargaJual': item['price'],
          'totalItemPrice': item['price'] * quantity,
        };
      }).toList(),
      'total': total,
    };

    // Save the sales data to sales history
    salesHistoryController.addSale(salesData);
    clearPesanan(); // Optionally clear the order after saving
  }
}
