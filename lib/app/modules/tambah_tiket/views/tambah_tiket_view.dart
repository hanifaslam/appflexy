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
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TambahTiketController controller = Get.put(TambahTiketController());

  @override
  void initState() {
    super.initState();
    if (widget.tiket != null) {
      namaTiketController.text = widget.tiket!['namaTiket'];
      stokController.text = widget.tiket!['stok'].toString();
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
          FocusScope.of(context).unfocus();
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
                TextField(
                  controller: stokController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Bootstrap.box,
                      color: Color(0xff181681),
                    ),
                    hintText: 'Stok',
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
                              stokController.text.isEmpty ||
                              hargaJualController.text.isEmpty ||
                              keteranganController.text.isEmpty) {
                            controller.errorMessage.value =
                                "Semua kolom harus diisi!";
                            return;
                          }

                          final userId = controller.box
                              .read('user_id'); // Get user_id from storage

                          Map<String, dynamic> tiketData = {
                            'namaTiket': namaTiketController.text,
                            'stok': int.tryParse(stokController.text) ?? 0,
                            'hargaJual':
                                double.tryParse(hargaJualController.text) ??
                                    0.0,
                            'keterangan': keteranganController.text,
                            'user_id': userId,
                          };

                          if (widget.tiket == null) {
                            controller.addTiket(tiketData);
                          } else {
                            final tiketId = widget.tiket?['id'];
                            if (tiketId != null) {
                              controller.updateTiket(tiketId, tiketData);
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
                              : 'Update Tiket',
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
