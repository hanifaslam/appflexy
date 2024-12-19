import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import '../controllers/edit_tiket_controller.dart';

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
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: controller.namaTiketController,
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
                    controller: controller.stokController,
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
                    controller: controller.hargaJualController,
                    decoration: InputDecoration(
                      hintText: 'Harga Tiket',
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
                    onChanged: controller.onCashInputChanged,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.keteranganController,
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
                      minimumSize: const Size(double.infinity, 50),
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
      ),
    );
  }
}