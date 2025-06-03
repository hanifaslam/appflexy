import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/modules/tambah_tiket/controllers/tambah_tiket_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart';

import '../../manajemen_tiket/controllers/manajemen_tiket_controller.dart';

class TambahTiketView extends StatefulWidget {
  final Map<String, dynamic>? tiket;
  final int? index;

  TambahTiketView({this.tiket, this.index});

  @override
  _TambahTiketViewState createState() => _TambahTiketViewState();
}

class _TambahTiketViewState extends State<TambahTiketView> {
  final TextEditingController namaTiketController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final TambahTiketController controller = Get.put(TambahTiketController());
  int stok = 0;
  bool showNominalOptions = false;

  // Modern color palette - sama dengan home_view.dart
  static const Color primaryBlue = Color(0xff181681);
  static const Color lightBlue = Color(0xFFE8E9FF);
  static const Color darkBlue = Color(0xff0F0B5C);
  static const Color accentBlue = Color(0xff2A23A3);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    if (widget.tiket != null) {
      namaTiketController.text = widget.tiket!['namaTiket'];
      stok = widget.tiket!['stok'] ?? 0;
      hargaJualController.text = widget.tiket!['hargaJual'].toString();
      keteranganController.text = widget.tiket!['keterangan'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      backgroundColor: primaryBlue, // Status bar akan mengikuti warna ini
      appBar: _buildModernAppBar(res),
      body: Container(
        color: backgroundColor,
        child: Column(
          children: [
            // Gradasi shadow di antara header dan content
            Container(
              height: res.hp(2.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    darkBlue.withOpacity(0.15),
                    darkBlue.withOpacity(0.10),
                    darkBlue.withOpacity(0.05),
                    Colors.black.withOpacity(0.03),
                    Colors.black.withOpacity(0.01),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),
            Expanded(child: _buildBody(res)),
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
            colors: [
              primaryBlue,
              darkBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(res.wp(5), res.hp(0.5), res.wp(5), res.hp(1.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: res.sp(22)),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: res.wp(2)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tiket == null ? 'Tambah Tiket' : 'Edit Tiket',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(20),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: res.hp(0.2)),
                          Text(
                            widget.tiket == null 
                                ? 'Buat tiket baru untuk acara Anda'
                                : 'Edit informasi tiket',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: res.sp(13),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AutoResponsive res) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showNominalOptions = false;
        });
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(res.wp(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error message
            Obx(() {
              if (controller.errorMessage.isNotEmpty) {
                return Container(
                  margin: EdgeInsets.only(bottom: res.hp(2)),
                  padding: EdgeInsets.all(res.wp(3)),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: res.sp(20)),
                      SizedBox(width: res.wp(2)),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: res.sp(14),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            // Form fields
            _buildModernFormCard(res),
            
            SizedBox(height: res.hp(4)),
            
            // Submit button
            _buildModernSubmitButton(res),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFormCard(AutoResponsive res) {
    return Container(
      padding: EdgeInsets.all(res.wp(5)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Tiket',
            style: TextStyle(
              color: textPrimary,
              fontSize: res.sp(18),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: res.hp(2.5)),

          // Nama Tiket Field
          _buildModernTextField(
            controller: namaTiketController,
            label: 'Nama Tiket',
            hint: 'Masukkan nama tiket',
            icon: Icons.confirmation_num_outlined,
            res: res,
          ),
          
          SizedBox(height: res.hp(2.5)),

          // Stok Field
          _buildModernStokField(res),
          
          SizedBox(height: res.hp(2.5)),

          // Harga Jual Field
          _buildModernTextField(
            controller: hargaJualController,
            label: 'Harga Jual',
            hint: 'Masukkan harga jual',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            res: res,
          ),
          
          SizedBox(height: res.hp(2.5)),

          // Keterangan Field
          _buildModernTextField(
            controller: keteranganController,
            label: 'Keterangan Tiket',
            hint: 'Masukkan keterangan tiket',
            icon: Icons.description_outlined,
            maxLines: 4,
            res: res,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AutoResponsive res,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textPrimary,
            fontSize: res.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: res.hp(0.8)),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: res.sp(14),
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: textSecondary,
                fontSize: res.sp(14),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                icon,
                color: primaryBlue,
                size: res.sp(20),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: res.wp(4),
                vertical: res.hp(1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernStokField(AutoResponsive res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stok Tiket',
          style: TextStyle(
            color: textPrimary,
            fontSize: res.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: res.hp(0.8)),
        
        Container(
          padding: EdgeInsets.all(res.wp(4)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: primaryBlue,
                size: res.sp(20),
              ),
              SizedBox(width: res.wp(3)),
              
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showNominalOptions = !showNominalOptions;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Stok',
                        style: TextStyle(
                          fontSize: res.sp(14),
                          color: textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: primaryBlue,
                        size: res.sp(20),
                      ),
                      Spacer(),
                      Text(
                        stok.toString(),
                        style: TextStyle(
                          fontSize: res.sp(16),
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: res.wp(2)),
              
              // Plus/Minus buttons
              Row(
                children: [
                  _buildStokButton(
                    icon: Icons.remove,
                    onPressed: () {
                      setState(() {
                        if (stok > 0) stok--;
                      });
                    },
                    res: res,
                  ),
                  SizedBox(width: res.wp(1)),
                  _buildStokButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        stok++;
                      });
                    },
                    res: res,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Quick add options
        if (showNominalOptions)
          Container(
            margin: EdgeInsets.only(top: res.hp(1)),
            padding: EdgeInsets.all(res.wp(3)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambah Stok Cepat:',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: res.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: res.hp(1)),
                Wrap(
                  spacing: res.wp(2),
                  runSpacing: res.hp(1),
                  children: [5, 10, 20, 50, 100].map((value) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          stok += value;
                          showNominalOptions = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: res.wp(3),
                          vertical: res.hp(0.8),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        '+$value',
                        style: TextStyle(
                          fontSize: res.sp(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStokButton({
    required IconData icon,
    required VoidCallback onPressed,
    required AutoResponsive res,
  }) {
    return Container(
      width: res.wp(8),
      height: res.wp(8),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: primaryBlue.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Icon(
            icon,
            color: primaryBlue,
            size: res.sp(16),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSubmitButton(AutoResponsive res) {
    return Container(
      width: double.infinity,
      height: res.hp(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Obx(() => controller.isLoading.value
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.tiket == null ? Icons.add : Icons.edit,
                    size: res.sp(18),
                  ),
                  SizedBox(width: res.wp(2)),
                  Text(
                    widget.tiket == null ? 'Tambah Tiket' : 'Update Tiket',
                    style: TextStyle(
                      fontSize: res.sp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )),
      ),
    );
  }

  void _handleSubmit() async {
    // Validation
    if (namaTiketController.text.isEmpty ||
        hargaJualController.text.isEmpty ||
        keteranganController.text.isEmpty) {
      controller.errorMessage.value = "Semua kolom harus diisi!";
      return;
    }

    if (stok <= 0) {
      controller.errorMessage.value = "Stok harus lebih dari 0!";
      return;
    }

    // Clear error message sebelum submit
    controller.errorMessage.value = "";

    final userId = controller.box.read('user_id');

    Map<String, dynamic> tiketData = {
      'namaTiket': namaTiketController.text,
      'stok': stok,
      'hargaJual': double.tryParse(hargaJualController.text) ?? 0.0,
      'keterangan': keteranganController.text,
      'user_id': userId,
    };

    try {
      bool success = false;

      if (widget.tiket == null) {
        // Add new tiket
        success = await controller.addTiket(tiketData);
      } else {
        // Update existing tiket
        final tiketId = widget.tiket?['id'];
        if (tiketId != null) {
          success = await controller.updateTiket(tiketId, tiketData);
        } else {
          controller.errorMessage.value = "ID Tiket tidak valid untuk update.";
          return;
        }
      }

      // Jika berhasil
      if (success) {
        // Refresh ManajemenTiketController jika terdaftar
        if (Get.isRegistered<ManajemenTiketController>()) {
          final manajemenController = Get.find<ManajemenTiketController>();
          await manajemenController.fetchTikets();
        }

        // Tunggu sebentar lalu kembali ke halaman sebelumnya
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pop(context, 'success');
      }
    } catch (e) {
      print('Error submitting tiket: $e');
      controller.errorMessage.value = "Terjadi kesalahan: ${e.toString()}";
    }
  }

  void _showSuccessNotification(String message) {
    final res = AutoResponsive(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: res.hp(0.5)),
          child: Row(
            children: [
              Container(
                width: res.wp(8),
                height: res.wp(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: res.sp(16),
                ),
              ),
              SizedBox(width: res.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Berhasil!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: res.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: res.sp(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: primaryBlue,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.fromLTRB(
          res.wp(4), 
          0, 
          res.wp(4), 
          res.hp(12), // Posisi lebih tinggi agar tidak tertutup bottom nav
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaTiketController.dispose();
    hargaJualController.dispose();
    keteranganController.dispose();
    super.dispose();
  }
}