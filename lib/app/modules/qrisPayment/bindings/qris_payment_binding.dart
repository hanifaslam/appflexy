import 'package:get/get.dart';

import '../controllers/qris_payment_controller.dart';

class QrisPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrisPaymentController>(
      () => QrisPaymentController(),
    );
  }
}
