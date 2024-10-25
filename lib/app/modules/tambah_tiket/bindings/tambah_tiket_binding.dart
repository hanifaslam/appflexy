import 'package:get/get.dart';

import '../controllers/tambah_tiket_controller.dart';

class TambahTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahTiketController>(
      () => TambahTiketController(),
    );
  }
}
