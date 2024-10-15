import 'package:get/get.dart';

import '../controllers/manajemen_tiket_controller.dart';

class ManajemenTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManajemenTiketController>(
      () => ManajemenTiketController(),
    );
  }
}
