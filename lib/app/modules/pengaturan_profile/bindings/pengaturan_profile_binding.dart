import 'package:get/get.dart';

import '../controllers/pengaturan_profile_controller.dart';

class PengaturanProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengaturanProfileController>(
      () => PengaturanProfileController(),
    );
  }
}
