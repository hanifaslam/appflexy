import 'package:get/get.dart';

class PembayaranCashController extends GetxController {
  RxList<Map<String, dynamic>> pesananList = <Map<String, dynamic>>[].obs;
  RxDouble total = 0.0.obs;

  // Tambahkan variabel untuk informasi perusahaan
  RxString companyName = 'Nama Perusahaan'.obs;
  RxString companyAddress = 'Alamat Perusahaan'.obs;

  // Tambah fungsi untuk hitung total
  void calculateTotal() {
    total.value = pesananList.fold(0.0, (sum, item) {
      return sum + (item['hargaJual'] * item['quantity']);
    });
  }

  void updateQuantity(int index, int delta) {
    pesananList[index]['quantity'] += delta;
    if (pesananList[index]['quantity'] <= 0) {
      pesananList.removeAt(index); // Hapus jika jumlah 0
    }
    calculateTotal();
  }
}
