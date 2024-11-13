import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package for currency formatting

class PembayaranCashController extends GetxController {
  // Observable list to store orders with item details
  RxList<Map<String, dynamic>> pesananList = <Map<String, dynamic>>[].obs;

  // Observable variable to store the total price
  RxDouble total = 0.0.obs;

  // Function to calculate the total price based on items in pesananList
  void calculateTotal() {
    total.value = pesananList.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  // Function to update the quantity of a specific item in pesananList
  void updateQuantity(int index, int delta) {
    // Modify the quantity by the specified delta (e.g., +1 or -1)
    pesananList[index]['quantity'] += delta;

    // Remove the item if quantity becomes zero or less
    if (pesananList[index]['quantity'] <= 0) {
      pesananList.removeAt(index);
    }

    // Recalculate the total after updating quantities
    calculateTotal();
  }

  // Method to format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Adjust for your local currency format
      symbol: 'Rp ', // Currency symbol
      decimalDigits: 2, // Number of decimal digits
    );
    return formatter.format(amount); // Format the amount as currency
  }
}
