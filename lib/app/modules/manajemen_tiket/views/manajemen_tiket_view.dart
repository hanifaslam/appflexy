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

  Future<void> _loadTiketList() async {
    try {
      final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/tikets'));
      if (response.statusCode == 200) {
        List<dynamic> tiketData = json.decode(response.body);
        setState(() {
          tiketList = List<Map<String, dynamic>>.from(tiketData);
          filteredTiketList = tiketList;
        });
      } else {
        print('Gagal memuat data tiket');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
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

  Future<void> _deleteTiketFromDatabase(int tiketId, int index) async {
    try {
      final response = await http
          .delete(Uri.parse('http://10.0.2.2:8000/api/tikets/$tiketId'));
      if (response.statusCode == 200) {
        setState(() {
          tiketList.removeAt(index);
          updateSearchQuery(searchQuery);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tiket berhasil dihapus.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus tiket.')),
        );
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  Future<void> _editTiketInDatabase(
      int tiketId, Map<String, dynamic> updatedTiketData, int index) async {
    // Buat salinan dari updatedTiketData agar kita bisa memodifikasinya
    final Map<String, dynamic> tiketDataToSend = {
      'id': updatedTiketData['id'],
      'namaTiket': updatedTiketData['namaTiket'],
      'stok': updatedTiketData['stok'],
      'hargaJual': updatedTiketData['hargaJual'],
      // Hanya tambahkan `keterangan` jika tidak null
      if (updatedTiketData['keterangan'] != null)
        'keterangan': updatedTiketData['keterangan'],
    };

    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/tikets/$tiketId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tiketDataToSend), // Kirim data JSON
      );

      if (response.statusCode == 200) {
        setState(() {
          tiketList[index] = updatedTiketData;
          updateSearchQuery(searchQuery);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tiket berhasil diperbarui.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui tiket.')),
        );
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff181681),
        toolbarHeight: 90,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Get.offAllNamed(Routes.HOME)),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          child: TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Cari Nama Tiket',
              prefixIcon: Icon(Icons.search_sharp),
              hintStyle: TextStyle(color: Color(0xff181681)),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[350],
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
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              _showSortDialog();
            },
          ),
        ],
      ),
      body: filteredTiketList.isEmpty
          ? Container(
        color: Colors.white24,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Bootstrap.box,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Tidak ada daftar tiket yang dapat ditampilkan.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )
          : Container(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: filteredTiketList.length,
              itemBuilder: (context, index) {
                final tiket = filteredTiketList[index];
                double hargaJual =
                    double.tryParse(tiket['hargaJual'].toString()) ?? 0.0;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // warna bayangan dengan opacity
                        spreadRadius: 2, // jarak sebaran bayangan
                        blurRadius: 6, // tingkat blur bayangan
                        offset: Offset(6, 10), // posisi bayangan (x, y)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(tiket['namaTiket'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Stok: ${tiket['stok']} |  ${currencyFormat.format(hargaJual)}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editTiket(index, tiket);
                            } else if (value == 'delete') {
                              _showDeleteDialog(index, tiket['id']);
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
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // warna bayangan dengan opacity
              spreadRadius: 2, // jarak sebaran bayangan
              blurRadius: 6, // tingkat blur bayangan
              offset: Offset(3, 5), // posisi bayangan (x, y)
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 4,
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
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(int index, int tiketId) {
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
                Navigator.of(context).pop();
                _deleteTiketFromDatabase(tiketId, index);
              },
            ),
          ],
        );
      },
    );
  }

  void _editTiket(int index, Map<String, dynamic> tiket) async {
    // ignore: unnecessary_null_comparison
    if (tiket == null) return;

    // Kirim tiket lengkap dengan ID ke `TambahTiketView`
    final result = await Get.to(TambahTiketView(
      tiket: tiket, // Tiket lengkap dengan ID
      index: index,
    ));

    if (result != null) {
      setState(() {
        tiketList[index] = result;
        updateSearchQuery(searchQuery);
      });
    }
  }
}