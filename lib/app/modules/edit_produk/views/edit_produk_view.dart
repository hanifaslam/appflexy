import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  @override
  void initState() {
    super.initState();
    controller.initializeProduk(widget.produk);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Edit Produk',
          style: const TextStyle(
              color: Color(0xff181681), fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<EditProdukController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        TextField(
                          controller: controller.namaProdukController,
                          decoration: InputDecoration(
                            hintText: 'Nama Produk',
                            prefixIcon: Icon(
                              Bootstrap.box,
                              color: Color(0xff181681),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.kodeProdukController,
                          decoration: InputDecoration(
                            hintText: 'Kode Produk',
                            prefixIcon: Icon(
                              Bootstrap.tags,
                              color: Color(0xff181681),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.kategoriController,
                          decoration: InputDecoration(
                            hintText: 'Kategori',
                            prefixIcon: Icon(
                              Bootstrap.list,
                              color: Color(0xff181681),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                        ),
                        const Gap(30),
                        TextField(
                          controller: controller.stokController,
                          decoration: InputDecoration(
                            hintText: 'Stok',
                            prefixIcon: Icon(
                              Bootstrap.box2,
                              color: Color(0xff181681),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const Gap(30),
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: controller.hasImage()
                                      ? controller.selectedImage != null
                                          ? Image.file(
                                              controller.selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  controller.getImageUrl()!,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xff181681),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Bootstrap.image,
                                                size: 30,
                                                color: Color(0xff181681),
                                              ),
                                            )
                                      : Icon(
                                          Bootstrap.image,
                                          size: 30,
                                          color: Color(0xff181681),
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.selectedImage != null
                                        ? 'Ganti Foto Produk'
                                        : 'Foto Produk yang Baru',
                                    style: const TextStyle(
                                      fontSize: 18,
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
                        const SizedBox(height: 8),
                        Text(
                          '*Ingin mengganti gambar? Pilih baru. Jika tidak, biarkan saja.',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 80, 79, 79),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.hargaJualController,
                          decoration: InputDecoration(
                            hintText: 'Harga Sewa',
                            prefixIcon: Icon(
                              IonIcons.cash,
                              color: Color(0xff181681),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Color(0xff181681), width: 2.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller.keteranganController,
                          decoration: InputDecoration(
                            hintText: 'Keterangan Produk (opsional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
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
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.produk != null) {
                      controller.updateProduct(widget.produk!['id']);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff181681),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Update Produk',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
