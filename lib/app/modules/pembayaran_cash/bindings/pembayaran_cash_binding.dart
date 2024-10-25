import 'package:get/get.dart';

import '../controllers/pembayaran_cash_controller.dart';

class PembayaranCashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembayaranCashController>(
      () => PembayaranCashController(),
    );
  }
}
