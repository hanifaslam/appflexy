import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/modules/tambah_tiket/controllers/tambah_tiket_controller.dart';

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tiket == null ? 'Tambah Tiket' : 'Edit Tiket',
          style: const TextStyle(
              color: Color(0xff181681), fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            showNominalOptions = false; // Menutup dropdown jika area lain disentuh
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  if (controller.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
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
                  decoration: InputDecoration(
                    hintText: 'Nama Tiket',
                    prefixIcon: Icon(
                      Bootstrap.ticket_detailed,
                      color: Color(0xff181681),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                        BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                ),
                const Gap(30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff181681), width: 2),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Bootstrap.box,
                              color: Color(0xff181681),
                            ),
                            const SizedBox(width: 12),
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
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xff181681),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Text(
                              stok.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              stok++;
                            });
                          },
                          icon: Icon(
                              Icons.add,
                              color: Color(0xff181681),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (stok > 0) stok--;
                            });
                          },
                          icon: Icon(Icons.remove, color: Color(0xff181681)),
                        ),
                      ],
                    ),
                  ],
                ),
                if (showNominalOptions)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xff181681), width: 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
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
                            backgroundColor: Color(0xff181681),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            '$value',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                const Gap(30),
                TextField(
                  controller: hargaJualController,
                  decoration: InputDecoration(
                    hintText: 'Harga Jual',
                    prefixIcon: Icon(
                      IonIcons.cash,
                      color: Color(0xff181681),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                        BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: keteranganController,
                  decoration: InputDecoration(
                    hintText: 'Keterangan Tiket',
                    hintStyle: TextStyle(color: Color(0xff181681)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide:
                        BorderSide(color: Color(0xff181681), width: 2.0)),
                  ),
                  maxLines: 4,
                ),
                const Gap(70),
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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