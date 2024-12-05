import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingQRISView extends StatefulWidget {
  const SettingQRISView({super.key});

  @override
  _SettingQRISViewState createState() => _SettingQRISViewState();
}

class _SettingQRISViewState extends State<SettingQRISView> {
  File? qrCodeImage;

  @override
  void initState() {
    super.initState();
    _loadQrCodeImage(); // Memuat QR Code saat halaman pertama kali dibuka
  }

  // Fungsi untuk memilih gambar QR Code dari galeri
  Future<void> pickQrCodeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/uploaded_qr_code.png';

        // Cek apakah file sudah ada
        final existingFile = File(filePath);
        if (await existingFile.exists()) {
          // Jika file ada, hapus file lama
          await existingFile.delete();
          print("QR Code lama dihapus.");
        }

        final savedImage = await File(pickedFile.path).copy(filePath);

        // Menyimpan gambar yang baru ke SharedPreferences
        setState(() {
          qrCodeImage = savedImage;
        });

        // Simpan path gambar QR Code
        _saveQrCodePath(savedImage.path);

        print("QR Code baru disalin ke: ${savedImage.path}");
      } catch (e) {
        print("Error saat memilih gambar: $e");
      }
    } else {
      print("Tidak ada gambar yang dipilih.");
    }
  }

  // Fungsi untuk menyimpan path gambar QR Code menggunakan SharedPreferences
  Future<void> _saveQrCodePath(String path) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('qrCodePath', path);
      print("QR Code Path Disimpan: $path");
    } catch (e) {
      print("Error saat menyimpan path QR Code: $e");
    }
  }

  // Fungsi untuk memuat path gambar QR Code dari SharedPreferences
  Future<void> _loadQrCodeImage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedPath = prefs.getString('qrCodePath');
      if (savedPath != null) {
        setState(() {
          qrCodeImage = File(savedPath);
        });
        print("QR Code Path Dimuat: $savedPath");
      } else {
        print("Tidak ada QR Code yang tersimpan.");
      }
    } catch (e) {
      print("Error saat memuat path QR Code: $e");
    }
  }

  // Fungsi untuk menghapus gambar QR Code
  Future<void> _deleteQrCode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Hapus path gambar dari SharedPreferences
      await prefs.remove('qrCodePath');
      print("QR Code Path Dihapus dari SharedPreferences.");

      // Cek apakah file gambar QR Code ada
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/uploaded_qr_code.png');
      if (await file.exists()) {
        // Hapus file gambar QR Code
        await file.delete();
        print("Gambar QR Code Dihapus.");
      } else {
        print("Tidak ada gambar yang ditemukan untuk dihapus.");
      }

      // Reset tampilan gambar QR Code setelah dihapus
      setState(() {
        qrCodeImage = null;
      });
    } catch (e) {
      print("Error saat menghapus QR Code: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan QRIS'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              qrCodeImage != null
                  ? Image.file(
                      qrCodeImage!,
                      width: 360,
                      height: 500,
                      fit: BoxFit.cover,
                    )
                  : const Text(
                      'Belum ada QR Code. Unggah file QR Code Anda.',
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 20),
              // Tombol untuk menghapus QR Code atau mengganti dengan tombol unggah
              qrCodeImage != null
                  ? ElevatedButton(
                      onPressed: _deleteQrCode,
                      child: const Text('Hapus QR Code',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        backgroundColor: Colors.red,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: pickQrCodeImage,
                      child: const Text('Unggah QR Code',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        backgroundColor: Colors.blue,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingQRISView(),
  ));
}
