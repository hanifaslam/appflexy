import 'package:get/get.dart';

import '../controllers/registrasi_controller.dart';

class RegistrasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrasiController>(
      () => RegistrasiController(),
      fenix: true, // This allows the controller to be recreated when accessed again
    );
  }
}
