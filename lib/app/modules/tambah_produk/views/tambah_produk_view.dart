import 'dart:io'; // Untuk menggunakan File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:gap/gap.dart';

class TambahProdukView extends StatefulWidget {
  final Map<String, dynamic>? produk; // Data produk yang akan diedit
  final int? index; // Index produk untuk di-update

  TambahProdukView({this.produk, this.index});

  @override
  _TambahProdukViewState createState() => _TambahProdukViewState();
}

class _TambahProdukViewState extends State<TambahProdukView> {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  String? kategoriValue;
  List<String> kategori = ['Elektronik', 'Fashion', 'Makanan', 'Minuman'];

  File? _selectedImage; // Untuk menyimpan gambar yang dipilih
  final ImagePicker _picker = ImagePicker(); // Instance dari ImagePicker

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      namaProdukController.text = widget.produk!['namaProduk'];
      kodeProdukController.text = widget.produk!['kodeProduk'];
      stokController.text = widget.produk!['stok'];
      hargaJualController.text = widget.produk!['hargaJual'];
      keteranganController.text = widget.produk!['keterangan'];
      kategoriValue = widget.produk!['kategori'];
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
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
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
                  controller: namaProdukController,
                  decoration: const InputDecoration(
                    hintText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: kodeProdukController,
                  decoration: const InputDecoration(
                    hintText: 'Kode Produk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  value: kategoriValue,
                  items: kategori.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      kategoriValue = newValue;
                    });
                  },
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
                        'Masukan Foto Produk',
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
                    hintText: 'Keterangan Produk',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const Gap(70),
                ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman sebelumnya dengan data produk
                    Map<String, dynamic> newProduk = {
                      'namaProduk': namaProdukController.text,
                      'kodeProduk': kodeProdukController.text,
                      'stok': stokController.text,
                      'hargaJual': hargaJualController.text,
                      'keterangan': keteranganController.text,
                      'kategori': kategoriValue,
                      'image': _selectedImage?.path, // Simpan path dari gambar
                    };
                    Get.back(result: newProduk); // Kirim data produk
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681), // Gunakan warna yang sesuai
                    minimumSize: const Size(double.infinity, 50), // Sesuaikan lebar dan tinggi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Bentuk tombol rounded
                    ),
                  ),
                  child: const Text(
                    'Tambahkan Produk',
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
