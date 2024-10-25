import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KasirController extends GetxController {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  RxList<Map<String, dynamic>> pesananList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    print("Initial pesananList: $pesananList");
  }

  // Calculate subtotal
  double get subtotal => pesananList.fold(0.0, (sum, item) {
        final price = double.tryParse(item['harga']?.toString() ?? '0') ??
            0; // Use 'harga' here
        final quantity = item['quantity'] ?? 1;
        return sum + (price * quantity);
      });

  // Calculate total
  double get total => subtotal;

  // Update quantity of a specific item in pesananList
  void updateQuantity(int index, int change) {
    final currentQuantity = pesananList[index]['quantity'] ?? 1;
    final newQuantity = currentQuantity + change;

    if (newQuantity > 0) {
      pesananList[index]['quantity'] = newQuantity;
      pesananList.refresh(); // Notify the view to update
    }
  }

  // Format currency
  String formatCurrency(double value) {
    return currencyFormat.format(value);
  }

  // Method to clear pesananList
  void clearPesanan() {
    pesananList.clear();
  }
}
