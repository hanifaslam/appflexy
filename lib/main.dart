import 'package:apptiket/app/modules/pembayaran_cash/controllers/pembayaran_cash_controller.dart';
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
  Get.put(TambahProdukController());
  Get.lazyPut(() => SalesHistoryController());
  Get.lazyPut(() => KasirController());
  Get.lazyPut(() => PembayaranCashController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
        }
      },
    );
  }
}
