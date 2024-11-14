import 'package:get/get.dart';

class GantiPasswordController extends GetxController {
  var passwordLama = ''.obs;
  var passwordBaru = ''.obs;
  var confirmPassword = ''.obs;

  var isLoading = false.obs;

  Future<void> gantiPassword() async {
    if (passwordBaru.value != confirmPassword.value) {
      Get.snackbar('Error', 'Password tidak sesuai!');
      return;
    }

    if (passwordLama.value.isEmpty || passwordBaru.value.isEmpty) {
      Get.snackbar('Error', 'Isi semua password terlebih dahulu!');
      return;
    }

    try {
      isLoading(true);

      // Assuming the response is successful
      Get.snackbar('Success', 'Password berhasil diganti.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal untuk menyimpan password.');
    } finally {
      isLoading(false);
    }
  }
}
