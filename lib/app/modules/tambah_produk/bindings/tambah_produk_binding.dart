import 'package:apptiket/app/modules/tambah_produk/controllers/tambah_produk_controller.dart';
import 'package:get/get.dart';

class TambahProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahProdukController>(
      () => TambahProdukController(),
    );
  }
}
