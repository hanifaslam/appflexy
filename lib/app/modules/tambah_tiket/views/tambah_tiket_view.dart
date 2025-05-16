import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/modules/tambah_tiket/controllers/tambah_tiket_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class TambahTiketView extends StatefulWidget {
  final Map<String, dynamic>? tiket;
  final int? index;

  TambahTiketView({this.tiket, this.index});

  @override
  _TambahTiketViewState createState() => _TambahTiketViewState();
}

class _TambahTiketViewState extends State<TambahTiketView> {
  final TextEditingController namaTiketController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TambahTiketController controller = Get.put(TambahTiketController());
  int stok = 0;
  bool showNominalOptions = false;

  @override
  void initState() {
    super.initState();
    if (widget.tiket != null) {
      namaTiketController.text = widget.tiket!['namaTiket'];
      stok = widget.tiket!['stok'] ?? 0;
      hargaJualController.text = widget.tiket!['hargaJual'].toString();
      keteranganController.text = widget.tiket!['keterangan'];
    }
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
          setState(() {
            showNominalOptions = false; // Menutup dropdown jika area lain disentuh
          });
        },
        child: Padding(
          padding: EdgeInsets.all(res.wp(4)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  if (controller.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: res.hp(2)),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: res.sp(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                TextField(
                  controller: namaTiketController,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: res.hp(7),
                        padding: EdgeInsets.symmetric(horizontal: res.wp(3)),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff181681), width: 2),
                          borderRadius: BorderRadius.circular(res.wp(3.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Bootstrap.box,
                              color: const Color(0xff181681),
                              size: res.sp(20),
                            ),
                            SizedBox(width: res.wp(3)),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showNominalOptions = !showNominalOptions;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Stok',
                                    style: TextStyle(
                                      fontSize: res.sp(16),
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: const Color(0xff181681),
                                    size: res.sp(22),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              stok.toString(),
                              style: TextStyle(
                                fontSize: res.sp(16),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: res.wp(2)),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              stok++;
                            });
                          },
                          icon: Icon(Icons.add, color: const Color(0xff181681), size: res.sp(22)),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (stok > 0) stok--;
                            });
                          },
                          icon: Icon(Icons.remove, color: const Color(0xff181681), size: res.sp(22)),
                        ),
                      ],
                    ),
                  ],
                ),
                if (showNominalOptions)
                  Container(
                    margin: EdgeInsets.only(top: res.hp(1)),
                    padding: EdgeInsets.all(res.wp(2)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xff181681), width: 1),
                      borderRadius: BorderRadius.circular(res.wp(2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [5, 10, 20, 50, 100].map((value) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              stok += value;
                              showNominalOptions = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff181681),
                            padding: EdgeInsets.symmetric(
                                vertical: res.hp(1), horizontal: res.wp(3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(res.wp(2)),
                            ),
                          ),
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: res.sp(14),
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Gap(res.hp(3)),
                TextField(
                  controller: hargaJualController,
                  style: TextStyle(fontSize: res.sp(16)),
                  decoration: InputDecoration(
                    hintText: 'Harga Jual',
                    hintStyle: TextStyle(fontSize: res.sp(16)),
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
                ),
                SizedBox(height: res.hp(2)),
                TextField(
                  controller: keteranganController,
                  style: TextStyle(fontSize: res.sp(16)),
                  decoration: InputDecoration(
                    hintText: 'Keterangan Tiket',
                    hintStyle: TextStyle(color: const Color(0xff181681), fontSize: res.sp(16)),
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
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    if (namaTiketController.text.isEmpty ||
                        hargaJualController.text.isEmpty ||
                        keteranganController.text.isEmpty) {
                      controller.errorMessage.value =
                      "Semua kolom harus diisi!";
                      return;
                    }

                    final userId = controller.box.read('user_id');

                    Map<String, dynamic> tiketData = {
                      'namaTiket': namaTiketController.text,
                      'stok': stok,
                      'hargaJual':
                      double.tryParse(hargaJualController.text) ?? 0.0,
                      'keterangan': keteranganController.text,
                      'user_id': userId,
                    };

                    if (widget.tiket == null) {
                      controller.addTiket(tiketData);
                      Get.back(result: tiketData);
                    } else {
                      final tiketId = widget.tiket?['id'];
                      if (tiketId != null) {
                        controller.updateTiket(tiketId, tiketData);
                        Get.back(result: tiketData);
                      } else {
                        controller.errorMessage.value =
                        "ID Tiket tidak valid untuk update.";
                      }
                    }
                  },
                  child: Obx(() => controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    widget.tiket == null
                        ? 'Tambah Tiket'
                        : 'Edit Tiket',
                    style: TextStyle(color: Colors.white, fontSize: res.sp(16)),
                  )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681),
                    minimumSize: Size(double.infinity, res.hp(6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(res.wp(5)),
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