import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:apptiket/app/modules/home/controllers/home_controller.dart';
import 'package:apptiket/app/modules/pembayaran_cash/controllers/pembayaran_cash_controller.dart';
import 'package:apptiket/app/modules/profile/controllers/profile_controller.dart';
import 'package:apptiket/app/modules/tambah_produk/controllers/tambah_produk_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/kasir/controllers/kasir_controller.dart';
import 'app/modules/sales_history/controllers/sales_history_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/splash.dart';

void main() async {
  await GetStorage.init();
  Get.put(DaftarKasirController());
  Get.put(TambahProdukController());
  Get.lazyPut(() => SalesHistoryController());
  Get.lazyPut(() => KasirController());
  Get.lazyPut(() => PembayaranCashController());
  Get.put(HomeController());
  Get.put(DaftarKasirController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute:
          '/home', // Ganti ke route yang kamu inginkan, misalnya '/login' atau '/dashboard'
      getPages: AppPages.routes,
    );

    // return FutureBuilder(
    //   future: Future.delayed(Duration(seconds: 2)),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return SplashScreen();
    //     } else {
    //       return GetMaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         title: "Application",
    //         initialRoute: _getInitialRoute(),
    //         getPages: AppPages.routes,
    //       );
    //     }
    //   },
    // );
  }

  String _getInitialRoute() {
    final token = box.read('token');
    final userId = box.read('user_id');
    final needsProfile = box.read('needsProfile') ?? false;

    if (token != null && userId != null) {
      if (needsProfile) {
        return Routes.PROFILE;
      }
      return Routes.HOME;
    }
    return Routes.LOGIN;
  }
}
