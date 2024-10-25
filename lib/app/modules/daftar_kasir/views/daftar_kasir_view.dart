import 'dart:io';
import 'package:apptiket/app/modules/kasir/views/kasir_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DaftarKasirView extends StatefulWidget {
  @override
  _DaftarKasirViewState createState() => _DaftarKasirViewState();
}

class _DaftarKasirViewState extends State<DaftarKasirView>
    with SingleTickerProviderStateMixin {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final box = GetStorage();
  List<Map<String, dynamic>> produkList = [];
  List<Map<String, dynamic>> tiketList = [];
  List<Map<String, dynamic>> pesananList = [];
  String searchQuery = '';
  int pesananCount = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // 2 tabs: produk & tiket
    _loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _loadData() {
    // Load produk and tiket list from storage
    produkList = List<Map<String, dynamic>>.from(
        box.read<List<dynamic>>('produkList') ?? []);
    tiketList = List<Map<String, dynamic>>.from(
        (box.read<List<dynamic>>('tiketList') ?? []).map((tiket) {
      tiket['namaTiket'] = tiket['namaTiket'] ?? ''; // Fallback for null values
      tiket['hargaJual'] =
          double.tryParse(tiket['hargaJual']?.toString() ?? '0') ?? 0.0;
      return tiket;
    }));
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  void addToPesanan(Map<String, dynamic> item) {
    setState(() {
      pesananList.add(item);
      pesananCount++;
    });
    Get.snackbar('Pesanan',
        '${item['namaProduk'] ?? item['namaTiket']} ditambahkan ke pesanan.');
  }

  List<Map<String, dynamic>> _filterList(
      List<Map<String, dynamic>> list, String nameKey) {
    if (searchQuery.isEmpty) return list;
    return list
        .where((item) => (item[nameKey]?.toString().toLowerCase() ?? '')
            .contains(searchQuery))
        .toList();
  }

  Widget _buildList(List<Map<String, dynamic>> list, String type) {
    String nameKey = type == 'produk' ? 'namaProduk' : 'namaTiket';

    List<Map<String, dynamic>> filteredList = _filterList(list, nameKey);

    return filteredList.isEmpty
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
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final item = filteredList[index];
              String title = item[nameKey] ?? '';
              double price =
                  double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0.0;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: type == 'produk' && item['image'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(item['image']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.image, size: 50), // Placeholder icon for Tiket
                  title: Text(title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(currencyFormat.format(price)),
                  onTap: () => addToPesanan(item),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Daftar Produk dan Tiket',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
          ),
          titleSpacing: 45,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Produk'),
              Tab(text: 'Tiket'),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed(Routes.HOME),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildList(produkList, 'produk'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildList(tiketList, 'tiket'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() =>
                KasirView(pesananList: pesananList)); // Pass pesananList here
          },
          child: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
