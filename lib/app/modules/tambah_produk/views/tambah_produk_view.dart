import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

import '../../../routes/app_pages.dart';
import '../controllers/tambah_produk_controller.dart';

class TambahProdukView extends StatefulWidget {
  final Map<String, dynamic>? produk;
  final int? index;

  TambahProdukView({this.produk, this.index});

  @override
  State<TambahProdukView> createState() => _TambahProdukViewState();
}

class _TambahProdukViewState extends State<TambahProdukView> {
  final List<String> categories = [
    'Makanan',
    'Minuman',
    'Alat Transportasi',
    'Alat Renang'
  ];

  final List<int> stockOptions = [5, 10, 20, 50, 100];
  bool showNominalOptions = false;
  // Modern color palette
  static const Color primaryBlue = Color(0xff181681);
  static const Color darkBlue = Color(0xff0F0B5C);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TambahProdukController());
    final res = AutoResponsive(context);

    controller.initializeProduk(widget.produk);

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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showNominalOptions = false;
                  });
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(res.wp(5)),
                        child: _buildModernFormCard(res, controller),
                      ),
                    ),
                    _buildModernSubmitButton(res, controller),
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
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () async {
                        Get.put(TambahProdukController()).clearFields();
                        Get.offAllNamed(Routes.DAFTAR_PRODUK);
                      },
                    ),
                    SizedBox(width: res.wp(2)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: res.sp(20),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: res.hp(0.2)),
                          Text(
                            widget.produk == null 
                                ? 'Tambahkan produk baru untuk inventaris Anda'
                                : 'Edit informasi produk',
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
  
  Widget _buildModernFormCard(AutoResponsive res, TambahProdukController controller) {
    return GetBuilder<TambahProdukController>(
      builder: (controller) {
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
                'Informasi Produk',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: res.sp(18),
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: res.hp(2.5)),

              // Nama Produk
              _buildModernTextField(
                controller: controller.namaProdukController,
                label: 'Nama Produk',
                hint: 'Masukkan nama produk',
                icon: Bootstrap.box,
                res: res,
              ),
              SizedBox(height: res.hp(2.5)),

              // Kode Produk
              _buildModernTextField(
                controller: controller.kodeProdukController,
                label: 'Kode Produk',
                hint: 'Masukkan kode produk',
                icon: Bootstrap.tags,
                res: res,
              ),
              SizedBox(height: res.hp(2.5)),

              // Kategori Produk
              _buildModernKategoriField(res, controller),
              SizedBox(height: res.hp(2.5)),

              // Stok Field
              _buildModernStokField(res, controller),
              SizedBox(height: res.hp(2.5)),

              // Foto Produk
              _buildModernFotoField(res, controller),
              SizedBox(height: res.hp(2.5)),

              // Harga Sewa
              _buildModernTextField(
                controller: controller.hargaJualController,
                label: 'Harga Sewa',
                hint: 'Masukkan harga sewa',
                icon: IonIcons.cash,
                keyboardType: TextInputType.number,
                res: res,
              ),
              SizedBox(height: res.hp(2.5)),

              // Keterangan
              _buildModernTextField(
                controller: controller.keteranganController,
                label: 'Keterangan Produk',
                hint: 'Masukkan keterangan produk (opsional)',
                icon: Bootstrap.chat_text_fill,
                maxLines: 4,
                res: res,
              ),
            ],
          ),
        );
      }
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

  Widget _buildModernKategoriField(AutoResponsive res, TambahProdukController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: TextStyle(
            color: textPrimary,
            fontSize: res.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: res.hp(0.8)),
        
        Container(
          padding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(1.5)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(
                Bootstrap.list,
                color: primaryBlue,
                size: res.sp(20),
              ),
              SizedBox(width: res.wp(3)),
              
              Expanded(
                child: Text(
                  controller.kategoriController.text.isEmpty
                    ? 'Pilih kategori produk'
                    : controller.kategoriController.text,
                  style: TextStyle(
                    fontSize: res.sp(14),
                    color: controller.kategoriController.text.isEmpty
                      ? textSecondary
                      : textPrimary,
                    fontWeight: controller.kategoriController.text.isEmpty
                      ? FontWeight.w400
                      : FontWeight.w500,
                  ),
                ),
              ),
              
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: primaryBlue,
                  size: res.sp(24),
                ),
                onSelected: (String value) {
                  controller.kategoriController.text = value;
                  controller.update();
                },
                itemBuilder: (BuildContext context) {
                  return categories.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(
                          fontSize: res.sp(14),
                          color: textPrimary,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildModernStokField(AutoResponsive res, TambahProdukController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stok Produk',
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
                Bootstrap.box2,
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
                        controller.stokController.text.isEmpty
                          ? '0'
                          : controller.stokController.text,
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
                      int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                      if (currentStock > 0) {
                        controller.stokController.text = (currentStock - 1).toString();
                        controller.update();
                      }
                    },
                    res: res,
                  ),
                  SizedBox(width: res.wp(1)),
                  _buildStokButton(
                    icon: Icons.add,
                    onPressed: () {
                      int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                      controller.stokController.text = (currentStock + 1).toString();
                      controller.update();
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
                  children: stockOptions.map((int stock) {
                    return ElevatedButton(
                      onPressed: () {
                        int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                        controller.stokController.text = (currentStock + stock).toString();
                        controller.update();
                        setState(() {
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
                        '+$stock',
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

  Widget _buildModernFotoField(AutoResponsive res, TambahProdukController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto Produk',
          style: TextStyle(
            color: textPrimary,
            fontSize: res.sp(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: res.hp(0.8)),
        
        GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: res.hp(2), horizontal: res.wp(4)),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                controller.selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        controller.selectedImage!,
                        width: res.wp(15),
                        height: res.wp(15),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: res.wp(15),
                      height: res.wp(15),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: primaryBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Bootstrap.image,
                        size: res.wp(8),
                        color: primaryBlue,
                      ),
                    ),
                SizedBox(width: res.wp(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.selectedImage != null
                          ? 'Ganti Foto Produk'
                          : 'Masukkan Foto Produk',
                        style: TextStyle(
                          fontSize: res.sp(14),
                          fontWeight: FontWeight.w500,
                          color: textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Format: JPG, PNG',
                        style: TextStyle(
                          fontSize: res.sp(12),
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.cloud_upload_outlined,
                  color: primaryBlue,
                  size: res.sp(22),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSubmitButton(AutoResponsive res, TambahProdukController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(res.wp(5)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Container(
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
          onPressed: () async {
            if (controller.namaProdukController.text.isEmpty ||
                controller.kodeProdukController.text.isEmpty ||
                controller.kategoriController.text.isEmpty ||
                controller.stokController.text.isEmpty ||
                controller.hargaJualController.text.isEmpty) {
              Get.snackbar('Error', 'Semua kolom harus diisi',
                  colorText: Colors.black.withOpacity(0.8),
                  barBlur: 15,
                  icon: const Icon(Icons.error, color: Colors.red),
                  duration: const Duration(seconds: 3),
                  snackPosition: SnackPosition.TOP);
              return;
            }
            await controller.addProduct();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.produk == null ? Icons.add : Icons.edit,
                size: res.sp(18),
              ),
              SizedBox(width: res.wp(2)),
              Text(
                'Tambahkan Produk',
                style: TextStyle(
                  fontSize: res.sp(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
