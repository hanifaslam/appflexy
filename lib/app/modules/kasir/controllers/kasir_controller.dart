import 'package:get/get.dart';

class KasirController extends GetxController {
  var adultTicketQuantity = 0.obs;
  var childTicketQuantity = 0.obs;

  var subtotal = 0.obs;
  var memberDiscount = 20000.obs;
  var totalPrice = 0.obs;

  void increaseAdultTicket() {
    adultTicketQuantity.value++;
    _updatePrices();
  }

  void decreaseAdultTicket() {
    if (adultTicketQuantity.value > 0) {
      adultTicketQuantity.value--;
      _updatePrices();
    }
  }

  void increaseChildTicket() {
    childTicketQuantity.value++;
    _updatePrices();
  }

  void decreaseChildTicket() {
    if (childTicketQuantity.value > 0) {
      childTicketQuantity.value--;
      _updatePrices();
    }
  }

  void _updatePrices() {
    subtotal.value = (adultTicketQuantity.value * 50000) + (childTicketQuantity.value * 35000);
    totalPrice.value = subtotal.value - memberDiscount.value;
  }
}
