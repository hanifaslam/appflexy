import 'dart:convert';
import 'package:apptiket/app/modules/tambah_tiket/views/tambah_tiket_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ManajemenTiketView extends StatefulWidget {
  @override
  _ManajemenTiketView createState() => _ManajemenTiketView();
}

class _ManajemenTiketView extends State<ManajemenTiketView> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final box = GetStorage();
  List<Map<String, dynamic>> tiketList = [];
  List<Map<String, dynamic>> filteredTiketList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTiketList();
  }

  // Load Data Tiket
  Future<void> _loadTiketList() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/tikets'));
      if (response.statusCode == 200) {
        List<dynamic> tiketData = json.decode(response.body);
        setState(() {
          tiketList = List<Map<String, dynamic>>.from(tiketData);
          filteredTiketList = tiketList;
        });
      } else {
        _showSnackBar('Gagal memuat data tiket.', Colors.red);
      }
    } catch (error) {
      _showSnackBar('Terjadi kesalahan: $error', Colors.red);
    }
  }

  // Search Tiket
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredTiketList = tiketList
          .where((tiket) =>
              tiket['namaTiket'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Sortir Tiket
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort Tiket"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sortOptionTile("A-Z (Ascending)", () {
                _sortTiket((a, b) => a['namaTiket'].compareTo(b['namaTiket']));
              }),
              _sortOptionTile("Z-A (Descending)", () {
                _sortTiket((a, b) => b['namaTiket'].compareTo(a['namaTiket']));
              }),
              _sortOptionTile("Urutan Terbaru", () {
                _sortTiket((a, b) =>
                    DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
              }),
              _sortOptionTile("Urutan Terlama", () {
                _sortTiket((a, b) =>
                    DateTime.parse(a['createdAt']).compareTo(DateTime.parse(b['createdAt'])));
              }),
            ],
          ),
        );
      },
    );
  }

  ListTile _sortOptionTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      onTap: () {
        onTap();
        Navigator.of(context).pop();
      },
    );
  }

  void _sortTiket(Comparator<Map<String, dynamic>> comparator) {
    setState(() {
      filteredTiketList.sort(comparator);
    });
  }

  // Hapus Tiket
  Future<void> _deleteTiketFromDatabase(int tiketId, int index) async {
    try {
      final response =
          await http.delete(Uri.parse('http://10.0.2.2:8000/api/tikets/$tiketId'));
      if (response.statusCode == 200) {
        setState(() {
          tiketList.removeAt(index);
          updateSearchQuery(searchQuery);
        });
        _showSnackBar('Tiket berhasil dihapus.', Colors.green);
      } else {
        _showSnackBar('Gagal menghapus tiket.', Colors.red);
      }
    } catch (error) {
      _showSnackBar('Terjadi kesalahan: $error', Colors.red);
    }
  }

  // Edit Tiket
  void _editTiket(int index, Map<String, dynamic> tiket) async {
    final result = await Get.to(TambahTiketView(tiket: tiket, index: index));
    if (result != null) {
      setState(() {
        tiketList[index] = result;
        updateSearchQuery(searchQuery);
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xff181681),
      toolbarHeight: 90,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed(Routes.HOME)),
      title: _buildSearchField(),
      actions: [_buildSortButton()],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      child: TextField(
        onChanged: updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari Nama Tiket',
          prefixIcon: Icon(Icons.search_sharp),
          fillColor: Colors.grey[350],
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      onPressed: _showSortDialog,
    );
  }

  Widget _buildBody() {
    return filteredTiketList.isEmpty
        ? _buildEmptyView()
        : ListView.builder(
            itemCount: filteredTiketList.length,
            itemBuilder: (context, index) {
              final tiket = filteredTiketList[index];
              return _buildTiketItem(tiket, index);
            },
          );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Bootstrap.box, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada daftar tiket yang dapat ditampilkan.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTiketItem(Map<String, dynamic> tiket, int index) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(tiket['namaTiket'], style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Stok: ${tiket['stok']} | ${currencyFormat.format(double.parse(tiket['hargaJual']))}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _editTiket(index, tiket);
            if (value == 'delete') _deleteTiketFromDatabase(tiket['id'], index);
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text("Edit Tiket")),
            PopupMenuItem(value: 'delete', child: Text("Hapus Tiket")),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      backgroundColor: Color(0xff181681),
      onPressed: () async {
        final result = await Get.to(TambahTiketView());
        if (result != null) {
          setState(() {
            tiketList.add(result);
            updateSearchQuery(searchQuery);
          });
        }
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
