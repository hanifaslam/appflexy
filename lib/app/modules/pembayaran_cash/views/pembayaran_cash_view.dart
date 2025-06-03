import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../widgets/struk_pembayaran.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import '../../sales_history/controllers/sales_history_controller.dart';
import '../controllers/pembayaran_cash_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

// Modern color palette
const Color primaryBlue = Color(0xff181681);
const Color lightBlue = Color(0xFFE8E9FF);
const Color darkBlue = Color(0xff0F0B5C);
const Color accentBlue = Color(0xff2A23A3);
const Color backgroundColor = Color(0xFFFAFAFA);
const Color cardColor = Colors.white;
const Color textPrimary = Color(0xFF1F2937);
const Color textSecondary = Color(0xFF6B7280);
const Color borderColor = Color(0xFFE5E7EB);

class PembayaranCashView extends StatefulWidget {
  @override
  _PembayaranCashViewState createState() => _PembayaranCashViewState();
}

class _PembayaranCashViewState extends State<PembayaranCashView> {
  final TextEditingController cashController = TextEditingController();
  final PembayaranCashController pembayaranController =
      Get.put(PembayaranCashController());
  final KasirController kasirController = Get.find<KasirController>();
  final SalesHistoryController salesHistoryController =
      Get.find<SalesHistoryController>();

  // Currency formatter
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  // Variable untuk melacak nominal yang sedang dipilih
  int? selectedNominal;

  @override
  void initState() {
    super.initState();
    cashController.text = currencyFormat.format(0);
  }

  void _onCashInputChanged(String value) {
    String formattedValue;
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isNotEmpty) {
      double parsedValue = double.parse(value);
      formattedValue = currencyFormat.format(parsedValue);
    } else {
      formattedValue = currencyFormat.format(0);
    }
    cashController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildModernAppBar(res),
      body: SafeArea(
        child: Column(
          children: [
            // Shadow effect
            Container(
              height: res.hp(1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    darkBlue.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(res.wp(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOrderSummaryCard(res),
                    SizedBox(height: res.hp(3)),
                    _buildCashInputSection(res),
                    SizedBox(height: res.hp(3)),
                    _buildNominalButtonsSection(res),
                    SizedBox(height: res.hp(4)),
                    _buildProcessPaymentButton(res),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  PreferredSizeWidget _buildModernAppBar(AutoResponsive res) {
    return PreferredSize(
      preferredSize: Size.fromHeight(res.hp(9)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryBlue, darkBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: res.wp(2.5),
              offset: Offset(0, res.hp(0.5)),
            ),
          ],
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: res.hp(1)),
                  child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: res.sp(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: res.hp(0.5)),
                      Text(
                        currencyFormat.format(kasirController.total),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: res.sp(20),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(AutoResponsive res) {
    return Card(
      elevation: 2,
      shadowColor: primaryBlue.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(res.wp(4)),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(res.wp(4)),
        child: Obx(() {
          final items = kasirController.getOrderItems();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long, 
                    color: accentBlue,
                    size: res.sp(22),
                  ),
                  SizedBox(width: res.wp(2)),
                  Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(
                      fontSize: res.sp(16),
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              Divider(
                height: res.hp(3),
                thickness: 1,
                color: borderColor,
              ),
              if (items.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: res.hp(2)),
                    child: Text(
                      'Tidak ada item dalam pesanan',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: res.sp(14),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length > 3 ? 3 : items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: res.hp(1.5)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: res.wp(8),
                            height: res.wp(8),
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius: BorderRadius.circular(res.wp(2)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${item.quantity}×',
                              style: TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: res.sp(14),
                              ),
                            ),
                          ),
                          SizedBox(width: res.wp(3)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: res.sp(14),
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                  ),
                                ),
                                SizedBox(height: res.hp(0.5)),
                                Text(
                                  currencyFormat.format(item.price),
                                  style: TextStyle(
                                    fontSize: res.sp(13),
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            currencyFormat.format(item.price * item.quantity),
                            style: TextStyle(
                              fontSize: res.sp(14),
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              if (items.length > 3)
                Padding(
                  padding: EdgeInsets.only(top: res.hp(0.5)),
                  child: Center(
                    child: Text(
                      '+ ${items.length - 3} item lainnya',
                      style: TextStyle(
                        fontSize: res.sp(12),
                        color: accentBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Divider(
                height: res.hp(3),
                thickness: 1,
                color: borderColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: res.sp(16),
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    currencyFormat.format(kasirController.total),
                    style: TextStyle(
                      fontSize: res.sp(18),
                      fontWeight: FontWeight.bold,
                      color: accentBlue,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCashInputSection(AutoResponsive res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Masukkan nominal uang yang diterima:',
          style: TextStyle(
            fontSize: res.sp(16),
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(res.wp(3.5)),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.06),
                blurRadius: res.wp(2.5),
                offset: Offset(0, res.hp(0.4)),
              ),
            ],
          ),
          child: TextField(
            controller: cashController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: res.sp(18),
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: cardColor,
              hintText: 'Rp 0',
              hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)),
              contentPadding: EdgeInsets.symmetric(
                horizontal: res.wp(4.5), 
                vertical: res.hp(2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(res.wp(3.5)),
                borderSide: BorderSide(color: primaryBlue, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(res.wp(3.5)),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              prefixIcon: Icon(
                Icons.payments_outlined, 
                color: accentBlue,
                size: res.sp(22),
              ),
            ),
            onChanged: _onCashInputChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildNominalButtonsSection(AutoResponsive res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Cepat',
          style: TextStyle(
            fontSize: res.sp(16),
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: res.hp(1.5)),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: res.width > 600 ? 3.5 : 2.5, // Wider buttons on larger screens
          mainAxisSpacing: res.hp(1.2),
          crossAxisSpacing: res.wp(2.5),
          children: [
            _buildNominalButton(20000, Colors.green, res),
            _buildNominalButton(50000, Colors.blue, res),
            _buildNominalButton(100000, Colors.red, res),
            _buildNominalButton(150000, Colors.purple, res),
            _buildNominalButton(200000, Colors.amber.shade700, res),
            _buildNominalButton(250000, Colors.orange, res),
          ],
        ),
      ],
    );
  }

  Widget _buildNominalButton(int nominal, Color baseColor, [AutoResponsive? responsive]) {
    final res = responsive ?? AutoResponsive(context);
    final bool isSelected = selectedNominal == nominal;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(3)),
        boxShadow: isSelected ? [
          BoxShadow(
            color: baseColor.withOpacity(0.5),
            blurRadius: res.wp(2.5),
            offset: Offset(0, res.hp(0.4)),
          )
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              selectedNominal = nominal;
            });
            cashController.text = currencyFormat.format(nominal.toDouble());
          },
          borderRadius: BorderRadius.circular(res.wp(4)),
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected ? baseColor : baseColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(res.wp(4)),
              border: Border.all(
                color: isSelected ? baseColor.withOpacity(0.8) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: res.wp(2), 
                vertical: res.hp(1.2)
              ),
              child: Text(
                currencyFormat.format(nominal),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: res.sp(14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProcessPaymentButton(AutoResponsive res) {
    return Container(
      height: res.hp(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.wp(4)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: res.wp(3),
            offset: Offset(0, res.hp(0.5)),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          final jumlahUang = double.tryParse(cashController.text
                  .replaceAll(RegExp(r'[^0-9]'), '')) ??
              0.0;
          final totalHarga = kasirController.total;

          if (jumlahUang < totalHarga) {
            Get.snackbar(
              'Pembayaran Gagal',
              'Jumlah uang tidak cukup untuk membayar total',
              backgroundColor: Colors.red.shade50,
              colorText: Colors.red.shade700,
              borderRadius: res.wp(2.5),
              margin: EdgeInsets.all(res.wp(2.5)),
              duration: Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              boxShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: res.wp(2.5),
                  offset: Offset(0, res.hp(0.4)),
                ),
              ],
            );
          } else {
            final kembalian = jumlahUang - totalHarga;

            Get.to(() => StrukPembayaranPage(
              totalPembelian: totalHarga,
              uangTunai: jumlahUang,
              kembalian: kembalian,
              orderItems: kasirController.getOrderItems(),
              orderDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            ));

            Get.snackbar(
              'Pembayaran Berhasil',
              'Pembayaran berhasil diproses. Kembalian: ${currencyFormat.format(kembalian)}',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade700,
              borderRadius: res.wp(2.5),
              margin: EdgeInsets.all(res.wp(2.5)),
              duration: Duration(seconds: 2),
              snackPosition: SnackPosition.BOTTOM,
              boxShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: res.wp(2.5),
                  offset: Offset(0, res.hp(0.4)),
                ),
              ],
            );
            Get.back();
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(res.wp(4)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: Colors.white, size: res.sp(22)),
            SizedBox(width: res.wp(2.5)),
            Text(
              'Proses Pembayaran', 
              style: TextStyle(
                color: Colors.white,
                fontSize: res.sp(16),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
