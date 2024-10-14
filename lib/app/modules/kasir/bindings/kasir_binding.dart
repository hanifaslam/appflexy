import 'package:get/get.dart';

import '../controllers/kasir_controller.dart';

class KasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KasirController>(
      () => KasirController(),
    );
  }
}
