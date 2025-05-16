import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

import '../controllers/edit_produk_controller.dart';

class EditProdukView extends StatefulWidget {
  final Map<String, dynamic>? produk;
  final int? index;

  EditProdukView({this.produk, this.index});

  @override
  State<EditProdukView> createState() => _EditProdukViewState();
}

class _EditProdukViewState extends State<EditProdukView> {
  final EditProdukController controller = Get.put(EditProdukController());

  final List<String> categories = [
    'Makanan',
    'Minuman',
    'Alat Transportasi',
    'Alat Renang'
  ];

  final List<int> stockOptions = [5, 10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    controller.initializeProduk(widget.produk);
  }

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: res.hp(8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Edit Produk',
          style: TextStyle(
            color: const Color(0xff181681),
            fontWeight: FontWeight.bold,
            fontSize: res.sp(18),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(res.wp(4)),
                child: GetBuilder<EditProdukController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        // Nama Produk
                        TextField(
                          controller: controller.namaProdukController,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: 'Nama Produk',
                            prefixIcon: Icon(
                              Bootstrap.box,
                              color: Color(0xff181681),
                              size: res.sp(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                        ),
                        Gap(res.hp(2)),

                        // Kode Produk
                        TextField(
                          controller: controller.kodeProdukController,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: 'Kode Produk',
                            prefixIcon: Icon(
                              Bootstrap.tags,
                              color: Color(0xff181681),
                              size: res.sp(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                        ),
                        Gap(res.hp(2)),

                        // Kategori
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(res.wp(3.5)),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: res.wp(3)),
                                child: Icon(
                                  Bootstrap.list,
                                  color: Color(0xff181681),
                                  size: res.sp(20),
                                ),
                              ),
                              SizedBox(width: res.wp(2)),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: res.hp(1.5)),
                                  child: Text(
                                    controller.kategoriController.text.isEmpty
                                        ? 'Kategori'
                                        : controller.kategoriController.text,
                                    style: TextStyle(
                                      color: controller.kategoriController.text.isEmpty
                                          ? Colors.grey[600]
                                          : Colors.black,
                                      fontSize: res.sp(16),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: res.wp(2)),
                                child: PopupMenuButton<String>(
                                  icon: Icon(Icons.arrow_drop_down, color: Color(0xff181681)),
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
                                          style: TextStyle(fontSize: res.sp(16)),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(res.hp(3)),

                        // Stok
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(res.wp(3.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(res.wp(3), res.hp(1.5), res.wp(3), 0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Bootstrap.box2,
                                      color: Color(0xff181681),
                                      size: res.sp(20),
                                    ),
                                    SizedBox(width: res.wp(2)),
                                    Text(
                                      'Stok',
                                      style: TextStyle(
                                        color: Color(0xff181681),
                                        fontSize: res.sp(16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline, size: res.sp(22)),
                                    onPressed: () {
                                      int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                                      if (currentStock > 0) {
                                        controller.stokController.text = (currentStock - 1).toString();
                                        controller.update();
                                      }
                                    },
                                  ),
                                  SizedBox(width: res.wp(5)),
                                  Text(
                                    controller.stokController.text.isEmpty
                                        ? '0'
                                        : controller.stokController.text,
                                    style: TextStyle(fontSize: res.sp(20)),
                                  ),
                                  SizedBox(width: res.wp(5)),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline, size: res.sp(22)),
                                    onPressed: () {
                                      int currentStock = int.tryParse(controller.stokController.text) ?? 0;
                                      controller.stokController.text = (currentStock + 1).toString();
                                      controller.update();
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(res.wp(3), 0, res.wp(3), res.hp(1.5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: stockOptions.map((int stock) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff181681),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(res.wp(5)),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: res.wp(4), vertical: res.hp(1)),
                                      ),
                                      onPressed: () {
                                        controller.stokController.text = stock.toString();
                                        controller.update();
                                      },
                                      child: Text('$stock', style: TextStyle(color: Colors.white, fontSize: res.sp(14))),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(res.hp(3)),

                        // Foto Produk
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: res.hp(2)),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(res.wp(2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: res.wp(13),
                                  height: res.wp(13),
                                  margin: EdgeInsets.only(left: res.wp(3)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(res.wp(2)),
                                  ),
                                  child: controller.hasImage()
                                      ? controller.selectedImage != null
                                          ? Image.file(
                                              controller.selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: controller.getImageUrl()!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Center(
                                                child: CircularProgressIndicator(
                                                  color: Color(0xff181681),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(
                                                Bootstrap.image,
                                                size: res.wp(13),
                                                color: Color(0xff181681),
                                              ),
                                            )
                                      : Icon(
                                          Bootstrap.image,
                                          size: res.wp(13),
                                          color: Color(0xff181681),
                                        ),
                                ),
                                SizedBox(width: res.wp(2)),
                                Expanded(
                                  child: Text(
                                    controller.selectedImage != null
                                        ? 'Ganti Foto Produk'
                                        : 'Foto Produk yang Baru',
                                    style: TextStyle(
                                      fontSize: res.sp(16),
                                      fontFamily: 'inter',
                                      fontStyle: FontStyle.normal,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(res.hp(2)),
                        Text(
                          '*Ingin mengganti gambar? Pilih baru. Jika tidak, biarkan saja.',
                          style: TextStyle(
                            fontSize: res.sp(14),
                            color: const Color.fromARGB(255, 80, 79, 79),
                          ),
                        ),
                        Gap(res.hp(2)),

                        // Harga Sewa
                        TextField(
                          controller: controller.hargaJualController,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: 'Harga Sewa',
                            prefixIcon: Icon(
                              IonIcons.cash,
                              color: Color(0xff181681),
                              size: res.sp(20),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        Gap(res.hp(2)),

                        // Keterangan
                        TextField(
                          controller: controller.keteranganController,
                          style: TextStyle(fontSize: res.sp(16)),
                          decoration: InputDecoration(
                            hintText: 'Keterangan Produk (opsional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(res.wp(3.5)),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                          maxLines: 4,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Bottom Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(res.wp(5)),
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.produk != null) {
                      controller.updateProduct(widget.produk!['id']);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681),
                    minimumSize: Size(double.infinity, res.hp(6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(res.wp(5)),
                    ),
                  ),
                  child: Text(
                    'Update Produk',
                    style: TextStyle(fontSize: res.sp(16), color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}