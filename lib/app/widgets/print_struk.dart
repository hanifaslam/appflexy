import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class BluetoothPrinterSelection extends StatefulWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<OrderItem> orderItems;
  final String orderDate;

  BluetoothPrinterSelection({
    required this.totalPembelian,
    required this.uangTunai,
    required this.kembalian,
    required this.orderItems,
    required this.orderDate,
  });

  @override
  _BluetoothPrinterSelectionState createState() =>
      _BluetoothPrinterSelectionState();
}

class _BluetoothPrinterSelectionState extends State<BluetoothPrinterSelection> {
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() async {
    try {
      devices = await printer.getBondedDevices();
      setState(() {});
    } catch (e) {
      print("Error getting bonded devices: $e");
    }
  }

  void connectPrinter() async {
    if (selectedDevice != null) {
      try {
        await printer.connect(selectedDevice!);
        setState(() {
          isConnected = true;
        });
      } catch (e) {
        print("Error connecting to printer: $e");
      }
    }
  }

  void disconnectPrinter() async {
    try {
      await printer.disconnect();
      setState(() {
        isConnected = false;
      });
    } catch (e) {
      print("Error disconnecting from printer: $e");
    }
  }

  void printStruk() {
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Printer belum terhubung!")),
      );
      return;
    }

    printer.printCustom("Toko Saya", 3, 1);
    printer.printCustom(widget.orderDate, 1, 0);
    printer.printNewLine();
    printer.printCustom("Detail Pesanan", 2, 1);
    for (var item in widget.orderItems) {
      printer.printCustom("${item.name} x${item.quantity} - Rp ${item.price}", 1, 0);
    }
    printer.printNewLine();
    printer.printCustom("Total Pembelian: Rp ${widget.totalPembelian}", 2, 0);
    printer.printCustom("Uang Tunai: Rp ${widget.uangTunai}", 1, 0);
    printer.printCustom("Kembalian: Rp ${widget.kembalian}", 1, 0);
    printer.printNewLine();
    printer.printCustom("Terima Kasih!", 2, 1);
    printer.printNewLine();
    printer.printNewLine();
    printer.paperCut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Printer Bluetooth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<BluetoothDevice>(
              onChanged: (BluetoothDevice? device) {
                setState(() {
                  selectedDevice = device;
                });
              },
              value: selectedDevice,
              hint: Text('Pilih Printer'),
              items: devices
                  .map((e) => DropdownMenuItem(
                child: Text(e.name ?? "Unknown"),
                value: e,
              ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectPrinter,
              child: Text('Connect Printer'),
            ),
            ElevatedButton(
              onPressed: isConnected ? disconnectPrinter : null,
              child: Text('Disconnect Printer'),
            ),
            ElevatedButton(
              onPressed: printStruk,
              child: Text('Print Struk'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
