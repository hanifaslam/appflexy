import 'package:get/get.dart';
import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';

class DaftarKasirBinding extends Bindings {
  @override
  void dependencies() {
    // Bind the DaftarKasirController to GetX dependency management
    Get.lazyPut<DaftarKasirController>(() => DaftarKasirController());
  }
}
