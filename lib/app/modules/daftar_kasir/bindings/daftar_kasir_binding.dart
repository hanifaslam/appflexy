import 'package:get/get.dart';

import '../controllers/daftar_kasir_controller.dart';

class DaftarKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarKasirController>(
      () => DaftarKasirController(),
    );
  }
}
