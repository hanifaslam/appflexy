import 'package:get/get.dart';

import '../controllers/sales_history_controller.dart';

class SalesHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesHistoryController>(() => SalesHistoryController());
  }
}