import 'package:get/get.dart';

import '../controllers/setting_q_r_i_s_controller.dart';

class SettingQRISBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingQRISController>(
      () => SettingQRISController(),
    );
  }
}
