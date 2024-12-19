import 'package:get/get.dart';

import '../modules/daftar_kasir/bindings/daftar_kasir_binding.dart';
import '../modules/daftar_kasir/views/daftar_kasir_view.dart';
import '../modules/daftar_produk/bindings/daftar_produk_binding.dart';
import '../modules/daftar_produk/views/daftar_produk_view.dart';
import '../modules/edit_produk/bindings/edit_produk_binding.dart';
import '../modules/edit_produk/views/edit_produk_view.dart';
import '../modules/edit_tiket/bindings/edit_tiket_binding.dart';
import '../modules/edit_tiket/views/edit_tiket_view.dart';
import '../modules/ganti_password/bindings/ganti_password_binding.dart';
import '../modules/ganti_password/views/ganti_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kasir/bindings/kasir_binding.dart';
import '../modules/kasir/views/kasir_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/manajemen_tiket/bindings/manajemen_tiket_binding.dart';
import '../modules/manajemen_tiket/views/manajemen_tiket_view.dart';
import '../modules/pembayaran_cash/bindings/pembayaran_cash_binding.dart';
import '../modules/pembayaran_cash/views/pembayaran_cash_view.dart';
import '../modules/pengaturan_profile/bindings/pengaturan_profile_binding.dart';
import '../modules/pengaturan_profile/views/pengaturan_profile_view.dart';
import '../modules/penjualan/bindings/penjualan_binding.dart';
import '../modules/penjualan/views/penjualan_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profileuser2/bindings/profileuser2_binding.dart';
import '../modules/profileuser2/views/profileuser2_view.dart';
import '../modules/qrisPayment/bindings/qris_payment_binding.dart';
import '../modules/qrisPayment/views/qris_payment_view.dart';
import '../modules/registrasi/bindings/registrasi_binding.dart';
import '../modules/registrasi/views/registrasi_view.dart';
import '../modules/sales_history/bindings/sales_history_binding.dart';
import '../modules/sales_history/views/sales_history_view.dart';
import '../modules/settingQRIS/bindings/setting_q_r_i_s_binding.dart';
import '../modules/settingQRIS/views/setting_q_r_i_s_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/struk/bindings/struk_binding.dart';
import '../modules/struk/views/struk_view.dart';
import '../modules/tambah_produk/bindings/tambah_produk_binding.dart';
import '../modules/tambah_produk/views/tambah_produk_view.dart';
import '../modules/tambah_tiket/bindings/tambah_tiket_binding.dart';
import '../modules/tambah_tiket/views/tambah_tiket_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_PRODUK,
      page: () => TambahProdukView(),
      binding: TambahProdukBinding(),
    ),
    GetPage(
      name: _Paths.PENJUALAN,
      page: () => PenjualanView(),
      binding: PenjualanBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.MANAJEMEN_TIKET,
      page: () => ManajemenTiketView(),
      binding: ManajemenTiketBinding(),
    ),
    GetPage(
      name: _Paths.KASIR,
      page: () => KasirView(
        pesananList: [],
      ),
      binding: KasirBinding(),
    ),
    GetPage(
      name: _Paths.DAFTAR_PRODUK,
      page: () => DaftarProdukView(),
      binding: DaftarProdukBinding(),
    ),
    GetPage(
      name: _Paths.PROFILEUSER2,
      page: () => Profileuser2View(),
      binding: Profileuser2Binding(),
    ),
    GetPage(
      name: _Paths.SALES_HISTORY,
      page: () => SalesHistoryView(),
      binding: SalesHistoryBinding(),
    ),
    GetPage(
      name: _Paths.TAMBAH_TIKET,
      page: () => TambahTiketView(),
      binding: TambahTiketBinding(),
    ),
    GetPage(
      name: _Paths.DAFTAR_KASIR,
      page: () => DaftarKasirView(),
      binding: DaftarKasirBinding(),
    ),
    GetPage(
      name: _Paths.PENGATURAN_PROFILE,
      page: () => PengaturanProfileView(),
      binding: PengaturanProfileBinding(),
    ),
    GetPage(
      name: _Paths.PEMBAYARAN_CASH,
      page: () => PembayaranCashView(),
      binding: PembayaranCashBinding(),
    ),
    GetPage(
      name: _Paths.STRUK,
      page: () => StrukView(
        receipt: Get.arguments,
      ),
      binding: StrukBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PRODUK,
      page: () => EditProdukView(),
      binding: EditProdukBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_TIKET,
      page: () => EditTiketView(),
      binding: EditTiketBinding(),
    ),
    GetPage(
      name: _Paths.GANTI_PASSWORD,
      page: () => GantiPasswordView(),
      binding: GantiPasswordBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRASI,
      page: () => RegistrasiView(),
      binding: RegistrasiBinding(),
    ),
    GetPage(
      name: _Paths.QRIS_PAYMENT,
      page: () => QrisPaymentView(),
      binding: QrisPaymentBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_Q_R_I_S,
      page: () => const SettingQRISView(),
      binding: SettingQRISBinding(),
    ),
  ];
}