import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TambahProdukView extends StatelessWidget {
  final TextEditingController namaProdukController = TextEditingController();
  final TextEditingController kodeProdukController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  String? kategoriValue;
  List<String> kategori = ['Elektronik', 'Fashion', 'Makanan', 'Minuman'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaProdukController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: kodeProdukController,
                decoration: const InputDecoration(
                  labelText: 'Kode Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
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
                  kategoriValue = newValue;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stokController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.image, size: 50),
                  SizedBox(width: 8),
                  Text(
                    'Masukan Foto Produk',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hargaJualController,
                decoration: const InputDecoration(
                  labelText: 'Harga Jual',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Produk',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Tambah produk action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Tambahkan Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
