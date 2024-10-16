import 'package:get/get.dart';

import '../controllers/daftar_produk_controller.dart';

class DaftarProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarProdukController>(
      () => DaftarProdukController(),
    );
  }
}
