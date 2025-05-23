import 'dart:io';
import 'dart:ui';
import 'package:apptiket/app/modules/pembayaran_cash/controllers/pembayaran_cash_controller.dart';
import 'package:apptiket/app/modules/pembayaran_cash/views/pembayaran_cash_view.dart';
import 'package:apptiket/app/modules/qrisPayment/views/qris_payment_view.dart';
import 'package:apptiket/app/modules/midtrans_payment/views/midtrans_payment_view.dart';
import 'package:apptiket/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:apptiket/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:apptiket/app/modules/sales_history/controllers/sales_history_controller.dart';
import 'package:apptiket/app/modules/daftar_kasir/controllers/daftar_kasir_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:apptiket/app/core/utils/auto_responsive.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';

class KasirView extends StatefulWidget {
  final List<Map<String, dynamic>> pesananList;

  KasirView({required this.pesananList});

  @override
  _KasirViewState createState() => _KasirViewState();
}

class _KasirViewState extends State<KasirView> {
  final KasirController controller = Get.put(KasirController());
  final SalesHistoryController salesHistoryController =
      Get.put(SalesHistoryController());
  final PembayaranCashController pembayaranCashController =
      Get.put(PembayaranCashController());
  List<double> itemPrices = [];
  List<Map<String, dynamic>> deletedItems = [];
  String? selectedPaymentMethod;
  var totalPrice = 0.0.obs;

  @override
  void initState() {
    super.initState();
    if (widget.pesananList.isNotEmpty) {
      itemPrices = widget.pesananList.map((item) {
        final double hargaJual =
            double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0;
        return hargaJual;
      }).toList();
      controller.initializeLocalQuantities();
    }
    calculateTotal();
  }

  void calculateTotal() {
    double total = 0;
    if (controller.pesananList.isNotEmpty) {
      for (int i = 0; i < controller.pesananList.length; i++) {
        if (i < itemPrices.length && i < controller.localQuantities.length) {
          total += itemPrices[i] * controller.localQuantities[i].value;
        }
      }
    }
    totalPrice.value = total;
    controller.total = total;
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context); // responsive helper

    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Pesanan',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xff181681),
            fontSize: res.sp(18),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: res.sp(20)),
          onPressed: () {
            controller.daftarKasirController.updatePesananCount();
            Get.offAllNamed(Routes.DAFTAR_KASIR);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            ),
          ),
          Expanded(
            child: controller.pesananList.isEmpty
                ? _buildEmptyState(res)
                : _buildOrderList(currencyFormat, res),
          ),
          _buildPaymentSection(currencyFormat, res),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AutoResponsive res) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: res.wp(25), color: Colors.grey),
          SizedBox(height: res.hp(2)),
          Text('Tidak ada pesanan.',
              style: TextStyle(color: Colors.grey, fontSize: res.sp(15))),
        ],
      ),
    );
  }

  Widget _buildOrderList(NumberFormat currencyFormat, AutoResponsive res) {
    return ListView.builder(
      padding: EdgeInsets.all(res.wp(4)),
      itemCount: controller.pesananList.length,
      itemBuilder: (context, index) =>
          _buildOrderItem(index, currencyFormat, res),
    );
  }

  Widget _buildProductImage(Map<String, dynamic> item, AutoResponsive res) {    if (item['image'] != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(res.wp(3)),
        child: SizedBox(
          width: res.wp(13),
          height: res.wp(13),
          child: CachedNetworkImage(
            imageUrl: item['image'].startsWith('http')
                ? item['image']
                : ApiConstants.getStorageUrl(item['image']),
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingPlaceholder(res),
            errorWidget: (context, url, error) => _buildErrorImage(res),
            cacheManager: CacheManager(
              Config(
                'customCacheKey',
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 100,
                repo: JsonCacheInfoRepository(databaseName: 'customCacheKey'),
                fileService: HttpFileService(httpClient: http.Client()),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: res.wp(13),
        height: res.wp(13),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(res.wp(3)),
        ),
        child: Icon(Icons.image, color: Colors.grey[400], size: res.sp(18)),
      );
    }
  }

  Widget _buildLoadingPlaceholder(AutoResponsive res) {
    return Container(
      width: res.wp(13),
      height: res.wp(13),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(res.wp(3)),
      ),
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildErrorImage(AutoResponsive res) {
    return Container(
      width: res.wp(13),
      height: res.wp(13),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(res.wp(3)),
      ),
      child:
          Icon(Icons.broken_image, color: Colors.grey[400], size: res.sp(18)),
    );
  }

  Widget _buildOrderItem(
      int index, NumberFormat currencyFormat, AutoResponsive res) {
    if (controller.pesananList.isEmpty ||
        controller.localQuantities.isEmpty ||
        index >= controller.pesananList.length ||
        index >= controller.localQuantities.length) {
      return Container();
    }
    final item = controller.pesananList[index];
    final double hargaJual =
        double.tryParse(item['hargaJual']?.toString() ?? '0') ?? 0;
    final String itemName = item['type'] == 'product'
        ? item['namaProduk'] ?? ''
        : item['namaTiket'] ?? '';
    final String formattedPrice = currencyFormat.format(hargaJual);

    return Container(
      padding: EdgeInsets.all(res.wp(3)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(res.wp(2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with larger size
              Container(
                width: res.wp(18),
                height: res.wp(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(res.wp(1.5)),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(res.wp(1.5)),
                  child: _buildProductImage(item, res),
                ),
              ),
              SizedBox(width: res.wp(3)),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: res.sp(14),
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      formattedPrice,
                      style: TextStyle(
                        fontSize: res.sp(14),
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom Controls
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: res.wp(23),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(res.wp(4)),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: res.wp(1), vertical: res.hp(0.5)),
              margin: EdgeInsets.only(top: res.hp(1)),
              child: Obx(() {
                if (controller.localQuantities.isEmpty ||
                    index >= controller.localQuantities.length) {
                  return Container();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        if (index < controller.localQuantities.length) {
                          if (controller.localQuantities[index].value > 1) {
                            controller.updateQuantity(index, -1);
                            calculateTotal();
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content:
                                      Text('Hapus item ini dari keranjang?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Batal'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text('Hapus'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        try {
                                          controller.removeItem(index);
                                          calculateTotal();
                                          // Update UI if cart is empty
                                          if (controller.pesananList.isEmpty) {
                                            setState(() {});
                                          }
                                        } catch (e) {
                                          print('Error handling delete: $e');
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(res.wp(1)),
                        child: controller.getQuantityIcon(index),
                      ),
                    ),
                    Text(
                      '${controller.localQuantities[index].value}',
                      style: TextStyle(fontSize: res.sp(14)),
                    ),
                    InkWell(
                      onTap: () {
                        controller.updateQuantity(index, 1);
                        calculateTotal();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(res.wp(1)),
                        child: Icon(
                          Icons.add,
                          size: res.sp(18),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(NumberFormat currencyFormat, AutoResponsive res) {
    return Container(
      padding: EdgeInsets.all(res.wp(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _showPaymentMethodDialog(context, res),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: res.wp(4), vertical: res.hp(1.2)),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(res.wp(2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        selectedPaymentMethod == 'Tunai'
                            ? CupertinoIcons.money_dollar
                            : Icons.qr_code_scanner,
                        color: const Color(0xff181681),
                        size: res.sp(20),
                      ),
                      SizedBox(width: res.wp(3)),
                      Text(
                        selectedPaymentMethod ?? 'Pilih Pembayaran',
                        style: TextStyle(
                            fontSize: res.sp(16), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    'Ganti',
                    style: TextStyle(
                        color: const Color(0xff181681),
                        fontWeight: FontWeight.w500,
                        fontSize: res.sp(14)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: res.hp(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style:
                          TextStyle(fontSize: res.sp(16), color: Colors.black),
                    ),
                    Obx(() => Text(
                          currencyFormat.format(controller.totalValue),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: res.sp(16),
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(width: res.wp(2)),
              ElevatedButton(
                onPressed: () => _processPayment(),
                child: Text(
                  'Jual',
                  style: TextStyle(fontSize: res.sp(16), color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff181681),
                  minimumSize: Size(res.wp(25), res.hp(6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(res.wp(3)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context, AutoResponsive res) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(res.wp(3))),
            title: Text('Pilih Metode Pembayaran',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: res.sp(16))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(CupertinoIcons.money_dollar,
                      color: const Color(0xff181681), size: res.sp(20)),
                  title: Text('Tunai', style: TextStyle(fontSize: res.sp(15))),
                  onTap: () {
                    setState(() => selectedPaymentMethod = 'Tunai');
                    controller.setPaymentMethod('Tunai');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code_scanner,
                      color: const Color(0xff181681), size: res.sp(20)),
                  title: Text('QRIS', style: TextStyle(fontSize: res.sp(15))),
                  onTap: () {
                    setState(() => selectedPaymentMethod = 'QRIS');
                    controller.setPaymentMethod('QRIS');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.payment,
                      color: const Color(0xff181681), size: res.sp(20)),
                  title: Text('Midtrans QRIS',
                      style: TextStyle(fontSize: res.sp(15))),
                  onTap: () {
                    setState(() => selectedPaymentMethod = 'Midtrans');
                    controller.setPaymentMethod('Midtrans');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processPayment() async {
    if (selectedPaymentMethod == null) {
      Get.snackbar(
        'Pilih Metode Pembayaran',
        'Silakan pilih metode pembayaran sebelum melanjutkan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (controller.total <= 0) {
      Get.snackbar(
        'Keranjang Kosong',
        'Silakan tambahkan item ke keranjang',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    controller.setPaymentMethod(selectedPaymentMethod!);
    final success = await controller.submitOrder();
    if (success) {
      if (selectedPaymentMethod == 'Tunai') {
        Get.to(() => PembayaranCashView());
      } else if (selectedPaymentMethod == 'QRIS') {
        Get.to(() => QrisPaymentView());
      } else if (selectedPaymentMethod == 'Midtrans') {
        // Get user data from storage or use default values
        final storage = GetStorage();
        final userName = storage.read('user_name') ?? 'Customer';
        final userEmail = storage.read('user_email') ?? 'customer@example.com';

        // Navigate to Midtrans Payment with required data
        Get.toNamed(Routes.MIDTRANS_PAYMENT, arguments: {
          'amount': controller.totalValue.toInt(),
          'name': userName,
          'email': userEmail,
        });
      }
    }
  }
}
