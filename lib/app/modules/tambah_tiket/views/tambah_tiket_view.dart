import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool isLoading = false; // Loading state
  String errorMessage = ''; // Error message to show above button

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

  Future<void> addTiket(Map<String, dynamic> tiketData) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/tikets'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(tiketData),
    );

    if (response.statusCode == 201) {
      Get.back(result: tiketData);
    } else {
      Get.snackbar("Error", "Gagal menambahkan tiket: ${response.body}");
      throw Exception('Failed to add tiket');
    }
  }

  Future<void> updateTiket(int id, Map<String, dynamic> tiketData) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/tikets/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(tiketData),
    );

    if (response.statusCode == 200) {
      tiketData['id'] = id;
      Get.back(result: tiketData);
    } else {
      Get.snackbar("Error", "Gagal mengupdate tiket: ${response.body}");
      throw Exception('Failed to update tiket');
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
                // Error message display
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                  onPressed: isLoading
                      ? null
                      : () {
                          // Validasi semua field
                          if (namaTiketController.text.isEmpty ||
                              stokController.text.isEmpty ||
                              hargaJualController.text.isEmpty ||
                              keteranganController.text.isEmpty) {
                            setState(() {
                              errorMessage =
                                  "Semua kolom harus diisi!"; // Pesan kesalahan
                            });
                            return;
                          }

                          setState(() {
                            isLoading = true;
                            errorMessage = ''; // Clear error message
                          });

                          Map<String, dynamic> tiketData = {
                            'namaTiket': namaTiketController.text,
                            'stok': int.tryParse(stokController.text) ?? 0,
                            'hargaJual':
                                double.tryParse(hargaJualController.text) ??
                                    0.0,
                            'keterangan': keteranganController.text,
                          };

                          try {
                            if (widget.tiket == null) {
                              addTiket(tiketData).whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            } else {
                              final tiketId = widget.tiket?['id'];
                              if (tiketId != null) {
                                updateTiket(tiketId, tiketData)
                                    .whenComplete(() {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              } else {
                                setState(() {
                                  errorMessage =
                                      "ID Tiket tidak valid untuk update.";
                                  isLoading = false;
                                });
                              }
                            }
                          } catch (e) {
                            Get.snackbar("Error", "Terjadi kesalahan: $e");
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Tambah Tiket',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
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
