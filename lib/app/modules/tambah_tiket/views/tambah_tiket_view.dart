import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import image_picker
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class TambahTiketView extends StatefulWidget {
  final Map<String, dynamic>? tiket; // Data tiket yang akan diedit
  final int? index; // Index tiket untuk di-update

  TambahTiketView({this.tiket, this.index});

  @override
  _TambahTiketViewState createState() => _TambahTiketViewState();
}

class _TambahTiketViewState extends State<TambahTiketView> {
  final TextEditingController namaTiketController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.tiket != null) {
      namaTiketController.text = widget.tiket!['namaTiket'];
      stokController.text = widget.tiket!['stok'];
      hargaJualController.text = widget.tiket!['hargaJual'];
      keteranganController.text = widget.tiket!['keterangan'];
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Simpan gambar yang dipilih
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tiket == null ? 'Tambah Tiket' : 'Edit Tiket',
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat mengetuk area kosong
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaTiketController,
                  decoration: const InputDecoration(
                    hintText: 'Nama Tiket',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(30),
                TextField(
                  controller: stokController,
                  decoration: const InputDecoration(
                    hintText: 'Stok',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const Gap(30),
                GestureDetector(
                  onTap: _pickImage, // Buka galeri saat ditekan
                  child: Row(
                    children: [
                      _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 100),
                      const SizedBox(width: 8),
                      const Text(
                        'Masukan Foto Tiket',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: hargaJualController,
                  decoration: const InputDecoration(
                    hintText: 'Harga Jual',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: keteranganController,
                  decoration: const InputDecoration(
                    hintText: 'Keterangan Tiket',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const Gap(70),
                ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman sebelumnya dengan data tiket
                    Map<String, dynamic> newTiket = {
                      'namaTiket': namaTiketController.text,
                      'stok': stokController.text,
                      'hargaJual': hargaJualController.text,
                      'keterangan': keteranganController.text,
                      'image': _selectedImage?.path, // Simpan path dari gambar
                    };
                    Get.back(result: newTiket); // Kirim data tiket
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff181681), // Gunakan warna yang sesuai
                    minimumSize: const Size(
                        double.infinity, 50), // Sesuaikan lebar dan tinggi
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Bentuk tombol rounded
                    ),
                  ),
                  child: const Text(
                    'Tambahkan tiket',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // Warna teks tombol putih
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
