import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/modules/tambah_tiket/views/tambah_tiket_view.dart';
import 'package:apptiket/app/modules/manajemen_tiket/controllers/manajemen_tiket_controller.dart';

class ManajemenTiketView extends GetView<ManajemenTiketController> {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 2,
  );

  ManajemenTiketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff181681),
      toolbarHeight: 90,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.offAllNamed(Routes.HOME),
      ),
      title: _buildSearchField(),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _showSortDialog(Get.context!),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari Nama Tiket',
          prefixIcon: const Icon(Icons.search_sharp),
          hintStyle: TextStyle(color: const Color(0xff181681)),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[350],
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredTiketList.isEmpty) {
        return _buildEmptyState();
      }

      return Column(
        children: [
          _buildTiketList(),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.white24,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Bootstrap.box, size: 100, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada daftar tiket yang dapat ditampilkan.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTiketList() {
    return Expanded(  // Changed from Flexible to Expanded
      child: Container(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            shrinkWrap: false, // Add this
            physics: const AlwaysScrollableScrollPhysics(), // Add this
            itemCount: controller.filteredTiketList.length,
            itemBuilder: (context, index) => _buildTiketCard(index),
          ),
        ),
      ),
    );
  }

  Widget _buildTiketCard(int index) {
    final tiket = controller.filteredTiketList[index];
    final double hargaJual =
        double.tryParse(tiket['hargaJual'].toString()) ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(6, 10),
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
            title: Text(
              tiket['namaTiket'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Stok: ${tiket['stok']} | ${currencyFormat.format(hargaJual)}',
            ),
            trailing: _buildPopupMenu(index, tiket),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(int index, Map<String, dynamic> tiket) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          _editTiket(Get.context!, index, tiket);
        } else if (value == 'delete') {
          _showDeleteDialog(Get.context!, tiket['id']);
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit Tiket'),
            ],
          ),
        ),
        const PopupMenuItem(
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
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(3, 5),
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 4,
        backgroundColor: const Color(0xff181681),
        onPressed: () async {
          final result = await Get.to(() => TambahTiketView());
          if (result != null) {
            controller.fetchTikets();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sort Tiket"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Ascending"),
                onTap: () {
                  controller.sortTikets(true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Descending"),
                onTap: () {
                  controller.sortTikets(false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int tiketId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah yakin ingin menghapus tiket ini?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteTiket(tiketId);
              },
            ),
          ],
        );
      },
    );
  }

  void _editTiket(
      BuildContext context, int index, Map<String, dynamic> tiket) async {
    if (tiket.isEmpty) return;

    final int tiketId = tiket['id'];
    final result =
        await Get.to(() => TambahTiketView(tiket: tiket, index: index));

    if (result != null) {
      final updatedData = Map<String, dynamic>.from({
        ...result,
        'id': tiketId,
      });

      try {
        await controller.updateTiket(tiketId, updatedData);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal mengupdate tiket: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
