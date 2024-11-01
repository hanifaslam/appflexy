import 'package:get/get.dart';

import '../controllers/edit_produk_controller.dart';

class EditProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProdukController>(
      () => EditProdukController(),
    );
  }
}
