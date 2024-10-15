import 'package:get/get.dart';
import '../../profileuser2/controllers/profileuser2_controller.dart';

class Profileuser2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Profileuser2Controller>(() => Profileuser2Controller());
  }
}
