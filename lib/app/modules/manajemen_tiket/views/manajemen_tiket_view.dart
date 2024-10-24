import 'dart:io'; // Untuk menggunakan File
import 'package:apptiket/app/modules/tambah_tiket/views/tambah_tiket_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ManajemenTiketView extends StatefulWidget {
  @override
  _ManajemenTiketView createState() => _ManajemenTiketView();
}

class _ManajemenTiketView extends State<ManajemenTiketView> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final box = GetStorage(); // Inisialisasi GetStorage
  List<Map<String, dynamic>> tiketList = [];
  List<Map<String, dynamic>> filteredTiketList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTiketList(); // Load data saat initState
  }

  void _loadTiketList() {
    
    List<dynamic>? storedTiketList = box.read<List<dynamic>>('tiketList');
    if (storedTiketList != null) {
      tiketList = List<Map<String, dynamic>>.from(storedTiketList);
      filteredTiketList = tiketList;
    }
  }

  void _saveTiketList() {
    
    box.write('tiketList', tiketList);
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredTiketList = tiketList
          .where((tiket) =>
              tiket['namaTiket'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort Tiket"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Ascending"),
                onTap: () {
                  setState(() {
                    filteredTiketList.sort(
                        (a, b) => a['namaTiket'].compareTo(b['namaTiket']));
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Descending"),
                onTap: () {
                  setState(() {
                    filteredTiketList.sort(
                        (a, b) => b['namaTiket'].compareTo(a['namaTiket']));
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(Routes.HOME)
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          child: TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Cari Nama Tiket',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[200],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showSortDialog();
            },
          ),
        ],
      ),
      body: filteredTiketList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada daftar tiket yang dapat ditampilkan.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan tiket untuk dapat menampilkan daftar tiket yang tersedia.',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: filteredTiketList.length,
                  itemBuilder: (context, index) {
                    final tiket = filteredTiketList[index];
                    double hargaJual =
                        double.tryParse(tiket['hargaJual'].toString()) ??
                            0.0; // Konversi hargaJual ke double

                    return Card(
                      color: Colors.grey[300],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: tiket['image'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(tiket['image']), // Tampilkan gambar
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.image, size: 50),
                        title: Text(tiket['namaTiket'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Stok: ${tiket['stok']} | ${currencyFormat.format(hargaJual)}', // Tampilkan harga yang diformat
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editTiket(index, tiket);
                            } else if (value == 'delete') {
                              _showDeleteDialog(index);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit Tiket'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 8),
                                  Text('Hapus Tiket'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(TambahTiketView());
          if (result != null) {
            setState(() {
              tiketList.add(result);
              _saveTiketList(); 
              updateSearchQuery(searchQuery);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah yakin ingin menghapus tiket ini?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  tiketList.removeAt(index);
                  _saveTiketList(); 
                  updateSearchQuery(searchQuery);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editTiket(int index, Map<String, dynamic> tiket) async {
    final result = await Get.to(TambahTiketView(
      tiket: tiket,
      index: index,
    ));
    if (result != null) {
      setState(() {
        tiketList[index] = result;
        _saveTiketList(); 
        updateSearchQuery(searchQuery);
      });
    }
  }
}
