import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:apptiket/app/modules/tambah_tiket/views/tambah_tiket_view.dart';
import 'package:apptiket/app/modules/manajemen_tiket/controllers/manajemen_tiket_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class ManajemenTiketView extends GetView<ManajemenTiketController> {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 2,
  );

  ManajemenTiketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: _buildAppBar(context, res),
      body: _buildBody(res),
      floatingActionButton: _buildFloatingActionButton(context, res),
    );
  }

  AppBar _buildAppBar(BuildContext context, AutoResponsive res) {
    return AppBar(
      backgroundColor: const Color(0xff181681),
      toolbarHeight: res.hp(11),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.offAllNamed(Routes.HOME),
      ),
      title: _buildSearchField(res),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () => _showSortDialog(context),
        ),
      ],
    );
  }

  Widget _buildSearchField(AutoResponsive res) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: res.wp(3), vertical: res.hp(1)),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Cari Nama Tiket',
          prefixIcon: const Icon(Icons.search_sharp),
          hintStyle: TextStyle(color: const Color(0xff181681), fontSize: res.sp(14)),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[350],
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(res.wp(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(res.wp(10)),
          ),
        ),
        style: TextStyle(fontSize: res.sp(14)),
      ),
    );
  }

  Widget _buildBody(AutoResponsive res) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredTiketList.isEmpty) {
        return _buildEmptyState(res);
      }

      return Column(
        children: [
          _buildTiketList(res),
        ],
      );
    });
  }

  Widget _buildEmptyState(AutoResponsive res) {
    return Container(
      color: Colors.white24,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Bootstrap.box, size: res.wp(30), color: Colors.grey),
            SizedBox(height: res.hp(2)),
            Text(
              'Tidak ada daftar tiket yang dapat ditampilkan.',
              style: TextStyle(color: Colors.grey, fontSize: res.sp(14)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTiketList(AutoResponsive res) {
    return Expanded(
      child: Container(
        color: Colors.white24,
        child: Padding(
          padding: EdgeInsets.all(res.wp(2.5)),
          child: ListView.builder(
            itemCount: controller.filteredTiketList.length,
            itemBuilder: (context, index) => _buildTiketCard(context, index, res),
          ),
        ),
      ),
    );
  }

  Widget _buildTiketCard(BuildContext context, int index, AutoResponsive res) {
    final tiket = controller.filteredTiketList[index];
    final double hargaJual =
        double.tryParse(tiket['hargaJual'].toString()) ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(res.wp(1.5), res.hp(1.5)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: res.hp(0.5)),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(3)),
          ),
          child: ListTile(
            title: Text(
              tiket['namaTiket'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: res.sp(15)),
            ),
            subtitle: Text(
              'Stok: ${tiket['stok']} | ${currencyFormat.format(hargaJual)}',
              style: TextStyle(fontSize: res.sp(13)),
            ),
            trailing: _buildPopupMenu(context, index, tiket, res),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(
      BuildContext context, int index, Map<String, dynamic> tiket, AutoResponsive res) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          _editTiket(context, index, tiket);
        } else if (value == 'delete') {
          _showDeleteDialog(context, tiket['id']);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: res.sp(16)),
              SizedBox(width: res.wp(2)),
              Text('Edit Tiket', style: TextStyle(fontSize: res.sp(14))),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: res.sp(16)),
              SizedBox(width: res.wp(2)),
              Text('Hapus Tiket', style: TextStyle(fontSize: res.sp(14))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, AutoResponsive res) {
    return FloatingActionButton(
      elevation: 4,
      backgroundColor: const Color(0xff181681),
      onPressed: () async {
        final result = await Get.to(() => TambahTiketView());
        if (result != null) {
          controller.fetchTikets();
        }
      },
      child: Icon(Icons.add, color: Colors.white, size: res.sp(24)),
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
