import 'dart:io'; // For using File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/modules/tambah_produk/views/tambah_produk_view.dart';
import 'package:apptiket/app/modules/daftar_produk/controllers/daftar_produk_controller.dart';

class DaftarProdukView extends StatefulWidget {
  @override
  _DaftarProdukViewState createState() => _DaftarProdukViewState();
}

class _DaftarProdukViewState extends State<DaftarProdukView> {
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 2);
  final box = GetStorage();
  final daftarProdukController = Get.find<DaftarProdukController>();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProdukList();
    daftarProdukController.fetchProducts();
  }

  void _loadProdukList() {
    List<dynamic>? storedProdukList = box.read<List<dynamic>>('produkList');
    if (storedProdukList != null) {
      daftarProdukController.products.value =
          List<Map<String, dynamic>>.from(storedProdukList);
    }
  }

  void _saveProdukList() {
    box.write('produkList', daftarProdukController.products);
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sort Produk"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Ascending"),
                onTap: () {
                  _sortProdukList(true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Descending"),
                onTap: () {
                  _sortProdukList(false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sortProdukList(bool ascending) {
    daftarProdukController.products.sort((a, b) {
      int comparison = a['namaProduk'].compareTo(b['namaProduk']);
      return ascending ? comparison : -comparison;
    });
    setState(() {}); // Rebuild to reflect changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: TextField(
            onChanged: updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Cari Nama Produk',
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
            icon: Icon(Icons.more_vert),
            onPressed: _showSortDialog,
          ),
        ],
      ),
      body: Obx(() {
        // Filter products based on search query
        final filteredProdukList =
            daftarProdukController.products.where((produk) {
          final namaProduk = produk['namaProduk'] as String?;
          return namaProduk != null &&
              namaProduk.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        return filteredProdukList.isEmpty
            ? _buildEmptyState()
            : _buildProductList(filteredProdukList);
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff181681),
        onPressed: () async {
          final result = await Get.to(TambahProdukView());
          if (result != null) {
            daftarProdukController.addProduct(result);
            _saveProdukList();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'Tidak ada daftar produk yang dapat ditampilkan.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Tambahkan produk untuk dapat menampilkan daftar produk yang tersedia.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<dynamic> filteredProdukList) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: filteredProdukList.length,
          itemBuilder: (context, index) {
            final produk = filteredProdukList[index];
            double hargaJual =
                double.tryParse(produk['hargaJual'].toString()) ?? 0.0;

            return Card(
              color: Colors.grey[300],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: produk['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(produk['image']),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.image, size: 50),
                title: Text(produk['namaProduk'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  'Stok: ${produk['stok']} | ${currencyFormat.format(hargaJual)}',
                ),
                trailing: _buildProductMenu(index, produk),
              ),
            );
          },
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildProductMenu(
      int index, Map<String, dynamic> produk) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          _editProduk(index, produk);
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
              Text('Edit Produk'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Hapus Produk'),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(index);
                Get.back(); // Close the dialog after deletion
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) async {
    final productId = daftarProdukController.products[index]['id'];
    final success = await daftarProdukController.deleteProduct(productId);

    if (success) {
      Get.snackbar('Sukses', 'Produk berhasil dihapus',
          backgroundColor: Colors.green, colorText: Colors.white);
      daftarProdukController.products.removeAt(index);
      _saveProdukList();
    } else {
      Get.snackbar('Error', 'Gagal menghapus produk',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _editProduk(int index, Map<String, dynamic> produk) async {
    final result = await Get.to(TambahProdukView(
      produk: produk,
    ));
    if (result != null) {
      daftarProdukController.updateProduct(index, result);
      _saveProdukList();
    }
  }
}
