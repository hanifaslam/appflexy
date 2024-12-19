import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditTiketController extends GetxController {
  final TextEditingController namaTiketController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  void initializeControllers(Map<String, dynamic>? tiket) {
    if (tiket != null) {
      print('Tiket data: $tiket'); // Log the tiket data
      namaTiketController.text = tiket['namaTiket'] ?? '';
      stokController.text = tiket['stok']?.toString() ?? '';
      hargaJualController.text = tiket['hargaJual']?.toString() ?? '';
      keteranganController.text = tiket['keterangan'] ?? '';
    } else {
      print('Tiket is null'); // Log if tiket is null
    }
  }

  void disposeControllers() {
    namaTiketController.dispose();
    stokController.dispose();
    hargaJualController.dispose();
    keteranganController.dispose();
  }

  void onCashInputChanged(String value) {
    String formattedValue;
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isNotEmpty) {
      double parsedValue = double.parse(value);
      formattedValue = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(parsedValue);
    } else {
      formattedValue = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(0);
    }
    hargaJualController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}