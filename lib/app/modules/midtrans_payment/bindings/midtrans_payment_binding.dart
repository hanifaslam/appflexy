import 'package:get/get.dart';
import '../controllers/midtrans_payment_controller.dart';

class MidtransPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MidtransPaymentController>(
      () => MidtransPaymentController(),
    );
  }
}
