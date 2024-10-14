import 'package:get/get.dart';

import '../controllers/tambah_produk_controller.dart';

class TambahProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahProdukController>(
      () => TambahProdukController(),
    );
  }
}
