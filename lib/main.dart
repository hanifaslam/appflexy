import 'package:apptiket/app/modules/tambah_produk/controllers/tambah_produk_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/widgets/splash.dart';

void main() async {
  await GetStorage.init();
  Get.put(ProdukController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: Routes.LOGIN,
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
    //         initialRoute: AppPages.INITIAL,
    //         getPages: AppPages.routes,
    //       );
    //     }
    //   },
    // );
  }
}
