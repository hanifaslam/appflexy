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

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff181681),
          title: Text(
            'Daftar Produk dan Tiket',
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Produk'),
              Tab(text: 'Tiket'),
            ],
            labelColor: Colors.white, // Color of selected tab
            unselectedLabelColor: Colors.grey, // Color of unselected tabs
            indicatorColor: Colors.blue, // Color of the indicator line below the tab
            indicatorWeight: 3.0, // Thickness of the indicator line
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () => Get.offAllNamed(Routes.HOME),
          ),
        ),


        body: TabBarView(
          children: [
            Obx(() => _buildList(controller.filteredProdukList, 'produk')),
            Obx(() => _buildList(controller.filteredTiketList, 'tiket')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
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
              ),
              if (controller.pesananCount > 0)
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8.0,
                    backgroundColor: Colors.red,
                    child: Text(
                      controller.pesananCount.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
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
        String title = item[type == 'produk' ? 'namaProduk' : 'namaTiket'] ?? '';
        double price = double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0.0;


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
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
              title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(currencyFormat.format(price)),
              onTap: () => controller.addToPesanan(item),
            ),
          ),
        );
      },
    );
  }
}
