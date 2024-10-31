import 'package:get/get.dart';

import '../controllers/edit_tiket_controller.dart';

class EditTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTiketController>(
      () => EditTiketController(),
    );
  }
}
