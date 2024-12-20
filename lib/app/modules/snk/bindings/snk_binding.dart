import 'package:get/get.dart';

import '../controllers/snk_controller.dart';

class SnkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnkController>(
      () => SnkController(),
    );
  }
}
