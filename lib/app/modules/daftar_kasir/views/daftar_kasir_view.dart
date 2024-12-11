import 'package:apptiket/app/modules/kasir/views/kasir_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';

class DaftarKasirView extends StatefulWidget {
  @override
  State<DaftarKasirView> createState() => _DaftarKasirViewState();
}

class _DaftarKasirViewState extends State<DaftarKasirView> {
  final DaftarKasirController controller = Get.put(DaftarKasirController());

  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff181681),
          title: Text(
            'Daftar Tiket dan Produk',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tiket'),
              Tab(text: 'Produk'),
            ],
            labelColor: Colors.white, // Color of selected tab
            unselectedLabelColor: Colors.grey, // Color of unselected tabs
            indicatorColor:
                Colors.blue, // Color of the indicator line below the tab
            indicatorWeight: 3.0, // Thickness of the indicator line
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Get.offAllNamed(Routes.HOME),
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildList(controller.filteredTiketList, 'tiket')),
            Obx(() => _buildList(controller.filteredProdukList, 'produk')),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 65, // Perluas area tombol untuk fleksibilitas
          height: 65,
          child: FloatingActionButton(
            backgroundColor: Color(0xff181681),
            onPressed: () {
              if (controller.pesananList.isEmpty) {
                Get.snackbar(
                  'Pesanan Kosong',
                  'Tambahkan produk atau tiket ke pesanan terlebih dahulu',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.to(() => KasirView(pesananList: controller.pesananList));
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
                Obx(() {
                  return controller.pesananCount > 0
                      ? Positioned(
                          right: 0, // Notifikasi bergeser keluar
                          top: 0, // Notifikasi bergeser ke atas
                          child: Container(
                            padding: EdgeInsets.all(4), // Padding notifikasi
                            decoration: BoxDecoration(
                              color: Colors.red, // Warna notifikasi
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 20, // Ukuran minimum notifikasi
                              minHeight: 10,
                            ),
                            child: Text(
                              controller.pesananCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : SizedBox.shrink(); // Tidak tampil jika pesananCount 0
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list, String type) {
    return list.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 100, color: Colors.grey),
                SizedBox(height: 16),
                Text('Tidak ada daftar $type yang dapat ditampilkan.',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              String title =
                  item[type == 'produk' ? 'namaProduk' : 'namaTiket'] ?? '';
              double price =
                  double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0.0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                child: Card(
                  color: Color(0xffE3E3E3),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: ListTile(
                    leading: type == 'produk' && item['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              item['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : type == 'produk'
                            ? Icon(Icons.image, size: 50)
                            : null,
                    title: Text(title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(currencyFormat.format(price)),
                    onTap: () => controller.addToPesanan(item),
                  ),
                ),
              );
            },
          );
  }
}
