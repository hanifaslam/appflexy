import 'dart:convert';
import 'package:bluetooth_print_plus/bluetooth_print_plus.dart' hide Alignment;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../modules/kasir/controllers/kasir_controller.dart';
import '../modules/pengaturan_profile/controllers/pengaturan_profile_controller.dart';
import '../core/utils/auto_responsive.dart';

// Modern color palette to match app theme
const Color primaryColor = Color(0xff181681);
const Color accentColor = Color(0xff2A23A3);
const Color successColor = Color(0xff16812f);
const Color errorColor = Color(0xffD32F2F);
const Color backgroundColor = Color(0xFFFAFAFA);
const Color cardColor = Colors.white;
const Color textPrimary = Color(0xFF1F2937);
const Color textSecondary = Color(0xFF6B7280);
const Color borderColor = Color(0xFFE5E7EB);

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
                  SnackBar(
                    content: Text('Terhubung ke perangkat ${_device!.name}'),
                    backgroundColor: successColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              break;
            case ConnectState.disconnected:
              _device = null;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Perangkat terputus'),
                  backgroundColor: errorColor,
                  behavior: SnackBarBehavior.floating,
                ),
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
        SnackBar(
          content: Text('Sudah terhubung ke ${device.name}'),
          backgroundColor: Colors.amber.shade700,
          behavior: SnackBarBehavior.floating,
        ),
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
        SnackBar(
          content: Text('Gagal menghubungkan: $e'),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // AutoResponsive setup
    final res = AutoResponsive(context);
    
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, accentColor],
            ),
          ),
        ),
        title: Text(
          'Perangkat Bluetooth',
          style: TextStyle(
            fontSize: res.sp(18),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: BluetoothPrintPlus.isBlueOn
              ? _scanResults.isEmpty
                  ? buildEmptyDeviceList(res)
                  : buildDeviceList(res)
              : buildBlueOffWidget(res),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (BluetoothPrintPlus.isBlueOn) buildScanButton(context, res),
          SizedBox(height: res.hp(1.5)),
          if (_device != null && _connectState == ConnectState.connected)
            buildPrintButton(res),
        ],
      ),
    );
  }

  Widget buildEmptyDeviceList(AutoResponsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: res.wp(30),
            height: res.wp(30),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bluetooth_searching,
              size: res.wp(15),
              color: primaryColor.withOpacity(0.7),
            ),
          ),
          SizedBox(height: res.hp(2)),
          Text(
            "Tidak ada perangkat",
            style: TextStyle(
              fontSize: res.sp(18),
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            "Tekan tombol SCAN untuk mencari perangkat",
            style: TextStyle(
              fontSize: res.sp(14),
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: res.hp(4)),
          ElevatedButton.icon(
            onPressed: onScanPressed,
            icon: Icon(Icons.search),
            label: Text("Mulai Pencarian"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(6),
                vertical: res.hp(1.5),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(res.wp(2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceList(AutoResponsive res) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(2)),
      itemCount: _scanResults.length,
      itemBuilder: (context, index) {
        final device = _scanResults[index];
        final isConnected = _connectState == ConnectState.connected && 
                          _device?.address == device.address;
        
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: res.hp(1.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(3)),
            side: BorderSide(
              color: isConnected ? primaryColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: res.wp(4), 
              vertical: res.hp(1)
            ),
            leading: Container(
              padding: EdgeInsets.all(res.wp(2)),
              decoration: BoxDecoration(
                color: isConnected 
                    ? primaryColor.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bluetooth,
                color: isConnected ? primaryColor : Colors.grey.shade700,
                size: res.wp(6),
              ),
            ),
            title: Text(
              device.name,
              style: TextStyle(
                fontSize: res.sp(16),
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            subtitle: Text(
              device.address,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: res.sp(12),
                color: textSecondary,
              ),
            ),
            trailing: ElevatedButton(
              onPressed: () => handleConnect(device),
              style: ElevatedButton.styleFrom(
                backgroundColor: isConnected 
                    ? successColor
                    : primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: res.wp(4),
                  vertical: res.hp(0.8),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(res.wp(2)),
                ),
                elevation: isConnected ? 0 : 2,
              ),
              child: Text(
                isConnected ? "Terhubung" : "Hubungkan",
                style: TextStyle(
                  fontSize: res.sp(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBlueOffWidget(AutoResponsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(res.wp(5)),
            decoration: BoxDecoration(
              color: errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bluetooth_disabled,
              size: res.wp(15),
              color: errorColor,
            ),
          ),
          SizedBox(height: res.hp(2)),
          Text(
            "Bluetooth tidak aktif",
            style: TextStyle(
              fontSize: res.sp(18),
              fontWeight: FontWeight.w600,
              color: errorColor,
            ),
          ),
          SizedBox(height: res.hp(1)),
          Text(
            "Silakan aktifkan Bluetooth pada perangkat Anda",
            style: TextStyle(
              fontSize: res.sp(14),
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildScanButton(BuildContext context, AutoResponsive res) {
    if (BluetoothPrintPlus.isScanningNow) {
      return FloatingActionButton(
        onPressed: onStopPressed,
        backgroundColor: errorColor,
        tooltip: 'Berhenti Mencari',
        child: Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: onScanPressed,
        backgroundColor: accentColor,
        label: Text(
          "SCAN",
          style: TextStyle(
            fontSize: res.sp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(Icons.bluetooth_searching),
      );
    }
  }
  
  Widget buildPrintButton(AutoResponsive res) {
    return FloatingActionButton.extended(
      onPressed: testPrint,
      backgroundColor: successColor,
      tooltip: 'Cetak Struk',
      label: Text(
        "Cetak Struk",
        style: TextStyle(
          fontSize: res.sp(14),
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: Icon(Icons.print, color: Colors.white),
      elevation: 4,
    );
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
        SnackBar(
          content: Text("Tidak ada perangkat yang terhubung!"),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {      
      // Ambil data perusahaan dari ProfileController
      final PengaturanProfileController profileController = Get.put(
          PengaturanProfileController());

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
        SnackBar(
          content: Text("Print berhasil"),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print("Print error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mencetak: $e"),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
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