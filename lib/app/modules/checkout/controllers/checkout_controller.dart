import 'package:get/get.dart';

class CheckoutController extends GetxController {
  var adultTicketQuantity = 1.obs; // Observable for adult ticket quantity
  var childTicketQuantity = 1.obs; // Observable for child ticket quantity
  var subtotal = 0.obs; // Observable for subtotal
  var total = 0.obs; // Observable for total after discount

  int adultTicketPrice = 50000;
  int childTicketPrice = 35000;
  int memberDiscount = 20000;

  // Method to update the total price
  void calculateTotal() {
    subtotal.value = (adultTicketQuantity.value * adultTicketPrice) +
        (childTicketQuantity.value * childTicketPrice);
    total.value = subtotal.value - memberDiscount;
  }

  // Increase and decrease methods
  void increaseAdultTicket() {
    adultTicketQuantity.value++;
    calculateTotal();
  }

  void decreaseAdultTicket() {
    if (adultTicketQuantity.value > 0) {
      adultTicketQuantity.value--;
      calculateTotal();
    }
  }

  void increaseChildTicket() {
    childTicketQuantity.value++;
    calculateTotal();
  }

  void decreaseChildTicket() {
    if (childTicketQuantity.value > 0) {
      childTicketQuantity.value--;
      calculateTotal();
    }
  }
}
