import 'dart:convert';

import 'package:apptiket/app/modules/pembayaran_cash/controllers/pembayaran_cash_controller.dart';
import 'package:apptiket/app/widgets/pdfpreview_page.dart';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../modules/kasir/controllers/kasir_controller.dart';
import '../modules/pembayaran_cash/views/pembayaran_cash_view.dart';
import '../modules/pengaturan_profile/controllers/pengaturan_profile_controller.dart';

class BluetoothPage extends StatefulWidget {
  final double totalPembelian;
  final double uangTunai;
  final double kembalian;
  final List<OrderItem> orderItems;
  final String orderDate;

  BluetoothPage({
    required this.totalPembelian,
    required this.uangTunai,
    required this.kembalian,
    required this.orderItems,
    required this.orderDate,
  });

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothDevice? _device;
  ConnectState _connectState = ConnectState.disconnected;
  late StreamSubscription<bool> _isScanningSubscription;
  late StreamSubscription<BlueState> _blueStateSubscription;
  late StreamSubscription<ConnectState> _connectStateSubscription;
  late StreamSubscription<Uint8List> _receivedDataSubscription;
  late StreamSubscription<List<BluetoothDevice>> _scanResultsSubscription;
  List<BluetoothDevice> _scanResults = [];

  @override
  void initState() {
    super.initState();
    initBluetoothPrintPlusListen();
  }

  Future<void> disconnectDevice() async {
    if (_device != null && _connectState == ConnectState.connected) {
      try {
        await BluetoothPrintPlus.disconnect();
        setState(() {
          _device = null;
          _connectState = ConnectState.disconnected;
        });
        print('Successfully disconnected from device');
      } catch (e) {
        print('Error disconnecting device: $e');
      }
    }
  }

  @override
  void dispose() {
    // Disconnect the device before disposing
    disconnectDevice().then((_) {
      // Cancel all stream subscriptions
      _isScanningSubscription.cancel();
      _blueStateSubscription.cancel();
      _connectStateSubscription.cancel();
      _receivedDataSubscription.cancel();
      _scanResultsSubscription.cancel();
      _scanResults.clear();
      super.dispose();
    });
  }

  Future<void> initBluetoothPrintPlusListen() async {
    _scanResultsSubscription = BluetoothPrintPlus.scanResults.listen((event) {
      if (mounted) {
        setState(() {
          _scanResults = event;
        });
      }
    });

    _isScanningSubscription = BluetoothPrintPlus.isScanning.listen((event) {
      print('********** isScanning: $event **********');
      if (mounted) {
        setState(() {});
      }
    });

    _blueStateSubscription = BluetoothPrintPlus.blueState.listen((event) {
      print('********** blueState change: $event **********');
      if (mounted) {
        setState(() {});
      }
    });

    _connectStateSubscription = BluetoothPrintPlus.connectState.listen((event) {
      print('********** connectState change: $event **********');
      if (mounted) {
        setState(() {
          _connectState = event;
          switch (event) {
            case ConnectState.connected:
              if (_device != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Terhubung ke perangkat ${_device!.name}')),
                );
              }
              break;
            case ConnectState.disconnected:
              _device = null;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Perangkat terputus')),
              );
              break;
          }
        });
      }
    });

    _receivedDataSubscription = BluetoothPrintPlus.receivedData.listen((data) {
      print('********** received data: $data **********');
    });
  }

  Future<void> handleConnect(BluetoothDevice device) async {
    if (_connectState == ConnectState.connected && _device?.address == device.address) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sudah terhubung ke ${device.name}')),
      );
      return;
    }

    try {
      setState(() {
        _device = device;
      });
      await BluetoothPrintPlus.connect(device);
    } catch (e) {
      print('Connection error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghubungkan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: SafeArea(
        child: BluetoothPrintPlus.isBlueOn
            ? ListView(
          children: _scanResults.map((device) => Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.name),
                      Text(
                        device.address,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Divider(),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => handleConnect(device),
                  child: Text(
                      _connectState == ConnectState.connected &&
                          _device?.address == device.address
                          ? "Connected"
                          : "Connect"
                  ),
                ),
              ],
            ),
          )).toList(),
        )
            : buildBlueOffWidget(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (BluetoothPrintPlus.isBlueOn) buildScanButton(context),
          SizedBox(height: 10),
          if (_device != null && _connectState == ConnectState.connected)
            FloatingActionButton(
              onPressed: testPrint,
              backgroundColor: Color(0xff181681),
              child: Icon(Icons.print, color: Colors.white),
              tooltip: "Test Print",
            ),
        ],
      ),
    );
  }

  // ... rest of the existing code remains the same ...

  Widget buildBlueOffWidget() {
    return Center(
      child: Text(
        "Bluetooth is turned off\nPlease turn on Bluetooth...",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildScanButton(BuildContext context) {
    if (BluetoothPrintPlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
        child: Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
        onPressed: onScanPressed,
        backgroundColor: Colors.green,
        child: Text("SCAN"),
      );
    }
  }

  Future onScanPressed() async {
    try {
      await BluetoothPrintPlus.startScan(timeout: Duration(seconds: 10));
    } catch (e) {
      print("onScanPressed error: $e");
    }
  }

  Future onStopPressed() async {
    try {
      BluetoothPrintPlus.stopScan();
    } catch (e) {
      print("onStopPressed error: $e");
    }
  }

  void testPrint() async {
    if (_device == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tidak ada perangkat yang terhubung!")),
      );
      return;
    }

    try {
      // Ambil data perusahaan dari ProfileController
      final PengaturanProfileController profileController = Get.put(
          PengaturanProfileController());
      final KasirController kasirController = Get.put(KasirController());

      // Gunakan nilai uangTunai yang dikirim melalui constructor
      final double uangTunai = widget.uangTunai;
      final double totalPembelian = widget.totalPembelian;
      final double kembalian = widget.kembalian;
      final List<OrderItem> orderItems = widget.orderItems;
      final String orderDate = widget.orderDate;

      final String companyName = profileController.companyName.value.isNotEmpty
          ? profileController.companyName.value
          : 'Nama Perusahaan Tidak Tersedia';

      final String companyAddress = profileController.companyAddress.value
          .isNotEmpty
          ? profileController.companyAddress.value
          : 'Alamat Tidak Tersedia';

      // Format mata uang
      final NumberFormat currencyFormat = NumberFormat.currency(
          locale: 'id', symbol: 'Rp ', decimalDigits: 2);

      // Buat string yang akan dicetak
      StringBuffer printData = StringBuffer();

      // Tambahkan nama perusahaan (tengah dan bold)
      printData.writeln(centerText("$companyName"));
      printData.writeln(centerText("_$companyAddress"));
      printData.writeln("");

      // Tanggal transaksi
      printData.writeln(centerText("Tanggal: $orderDate"));
      printData.writeln("--------------------------------");

      // Detail pembelian
      printData.writeln("Detail Pembelian:");
      orderItems.map((item) {
        return "${item.name} x${item.quantity} ${currencyFormat.format(
            item.price * item.quantity)}";
      }).forEach((row) {
        printData.writeln(row);
      });

      printData.writeln("--------------------------------");
      printData.writeln(rightAlignText("Total Pembelian: ", currencyFormat.format(totalPembelian)));
      if (uangTunai > 0) {
        printData.writeln(rightAlignText("Uang Tunai: ", currencyFormat.format(uangTunai)));
        printData.writeln(rightAlignText("Kembalian: ", currencyFormat.format(kembalian)));
      }
      printData.writeln("");
      printData.writeln("Terima Kasih Telah Berkunjung");
      printData.writeln("");
      printData.writeln("");
      printData.writeln("");

      // Konversi string ke bytes
      List<int> bytes = utf8.encode(printData.toString());

      // Kirim ke printer
      final result = await BluetoothPrintPlus.write(Uint8List.fromList(bytes));
      print("Print result: $result");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Print berhasil")),
      );
    } catch (e) {
      print("Print error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mencetak: $e")),
      );
    }
  }

// Fungsi untuk membuat teks di tengah
  String centerText(String text, {int lineWidth = 32}) {
    if (text.length >= lineWidth) return text;
    final int spaces = (lineWidth - text.length) ~/ 2;
    return "${" " * spaces}$text";
  }

  String rightAlignText(String label, String value, {int lineWidth = 32}) {
    final int totalLength = label.length + value.length;
    if (totalLength >= lineWidth) return "$label$value"; // Jika terlalu panjang
    final int spaces = lineWidth - totalLength;
    return "$label${" " * spaces}$value";
  }

}

  class LineText {
  static const int TYPE_TEXT = 0;
  static const String ALIGN_LEFT = 'left';
  static const String ALIGN_CENTER = 'center';
  static const String ALIGN_RIGHT = 'right';

  final int type;
  final String content;
  final String align;
  final int weight;
  final int linefeed;

  LineText({
    required this.type,
    required this.content,
    required this.align,
    required this.weight,
    required this.linefeed,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': 'text', // Selalu gunakan 'text' untuk type
      'content': content,
      'align': align,
      'weight': weight,
      'linefeed': linefeed,
    };
  }
}