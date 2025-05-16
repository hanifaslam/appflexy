import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import '../controllers/edit_tiket_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class EditTiketView extends StatefulWidget {
  final Map<String, dynamic>? tiket;
  final int? index;

  EditTiketView({this.tiket, this.index});

  @override
  _EditTiketViewState createState() => _EditTiketViewState();
}

class _EditTiketViewState extends State<EditTiketView> {
  final EditTiketController controller = Get.put(EditTiketController());

  @override
  void initState() {
    super.initState();
    controller.initializeControllers(widget.tiket);
  }

  @override
  void dispose() {
    controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: res.hp(8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tiket == null ? 'Tambah Tiket' : 'Edit Tiket',
          style: TextStyle(
              color: const Color(0xff181681),
              fontWeight: FontWeight.bold,
              fontSize: res.sp(18)),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: controller.namaTiketController,
                  style: TextStyle(fontSize: res.sp(16)),
                  decoration: InputDecoration(
                    hintText: 'Nama Tiket',
                    hintStyle: TextStyle(fontSize: res.sp(16)),
                    prefixIcon: Icon(
                      Bootstrap.ticket_detailed,
                      color: const Color(0xff181681),
                      size: res.sp(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide:
                        const BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                ),
                Gap(res.hp(3)),
                TextField(
                  controller: controller.stokController,
                  style: TextStyle(fontSize: res.sp(16)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Bootstrap.box,
                      color: const Color(0xff181681),
                      size: res.sp(20),
                    ),
                    hintText: 'Stok',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide:
                        const BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Gap(res.hp(3)),
                TextField(
                  controller: controller.hargaJualController,
                  style: TextStyle(fontSize: res.sp(16)),
                  decoration: InputDecoration(
                    hintText: 'Harga Tiket',
                    prefixIcon: Icon(
                      IonIcons.cash,
                      color: const Color(0xff181681),
                      size: res.sp(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide:
                        const BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: controller.onCashInputChanged,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.keteranganController,
                  style: TextStyle(fontSize: res.sp(16)),
                  decoration: InputDecoration(
                    hintText: 'Keterangan Tiket',
                    hintStyle: TextStyle(color: Color(0xff181681)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(res.wp(3.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(res.wp(3)),
                        borderSide:
                        const BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                  maxLines: 4,
                ),
                Gap(res.hp(7)),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> updatedTiket = {
                      'namaTiket': controller.namaTiketController.text,
                      'stok': int.tryParse(controller.stokController.text) ?? 0,
                      'hargaJual': double.tryParse(controller.hargaJualController.text
                          .replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                      'keterangan': controller.keteranganController.text,
                    };
                    Get.back(result: updatedTiket);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681),
                    minimumSize: Size(double.infinity, res.hp(6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    widget.tiket == null ? 'Tambahkan Tiket' : 'Update Tiket',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}