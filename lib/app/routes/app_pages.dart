import 'package:apptiket/app/modules/penjualan/bindings/penjualan_binding.dart';
import 'package:apptiket/app/modules/penjualan/views/penjualan_view.dart';
import 'package:apptiket/app/modules/profile/bindings/profile_binding.dart';
import 'package:get/get.dart';

import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/tambah_produk/bindings/tambah_produk_binding.dart';
import '../modules/tambah_produk/views/tambah_produk_view.dart';

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
      name: _Paths.CHECKOUT,
      page: () => CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
  ];
}
