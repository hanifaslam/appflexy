import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import '../controllers/tambah_produk_controller.dart';

class TambahProdukView extends StatefulWidget {
  final Map<String, dynamic>? produk;
  final int? index;

  const TambahProdukView({Key? key, this.produk, this.index}) : super(key: key);

  @override
  State<TambahProdukView> createState() => _TambahProdukViewState();
}

class _TambahProdukViewState extends State<TambahProdukView> {
  final TambahProdukController controller = Get.put(TambahProdukController());

  @override
  void initState() {
    super.initState();
    controller.initializeProduk(widget.produk);
  }

  void _submit() {
    if (_validateFields()) {
      controller.saveProduk().then((success) {
        if (success) {
          // Add a delay to allow snackbar to finish displaying
          Future.delayed(Duration(seconds: 2), () {
            Get.back(result: controller.createProdukData());
          });
        } else {
          Get.snackbar('Error', 'Failed to save product. Please try again.');
        }
      });
    }
  }

  bool _validateFields() {
    // Check if fields are empty or invalid
    if (controller.namaProdukController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Nama Produk cannot be empty');
      return false;
    }
    if (controller.kodeProdukController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Kode Produk cannot be empty');
      return false;
    }
    if (controller.kategoriController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Kategori cannot be empty');
      return false;
    }
    if (controller.stokController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Stok cannot be empty');
      return false;
    }
    if (controller.hargaJualController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Harga Jual cannot be empty');
      return false;
    }
    return true; // All validations passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
          style: const TextStyle(
            color: Color(0xff181681),
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<TambahProdukController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        _buildTextField(
                          controller: controller.namaProdukController,
                          hintText: 'Nama Produk',
                          prefixIcon: Bootstrap.box,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: controller.kodeProdukController,
                          hintText: 'Kode Produk',
                          prefixIcon: Bootstrap.tags,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: controller.kategoriController,
                          hintText: 'Kategori',
                          prefixIcon: Bootstrap.list,
                        ),
                        const Gap(30),
                        _buildTextField(
                          controller: controller.stokController,
                          hintText: 'Stok',
                          prefixIcon: Bootstrap.box2,
                          keyboardType: TextInputType.number,
                        ),
                        const Gap(30),
                        _buildImagePicker(controller),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: controller.hargaJualController,
                          hintText: 'Harga Jual',
                          prefixIcon: IonIcons.cash,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: controller.keteranganController,
                          hintText: 'Keterangan Produk (opsional)',
                          maxLines: 4,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: const Color(0xff181681),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: Color(0xff181681),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildImagePicker(TambahProdukController controller) {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.selectedImage != null
                  ? Image.file(
                      controller.selectedImage!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Bootstrap.image,
                      size: 50,
                      color: Color(0xff181681),
                    ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  controller.selectedImage != null
                      ? 'Ganti Foto Produk'
                      : 'Masukan Foto Produk',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
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
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff181681),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            widget.produk == null ? 'Tambahkan Produk' : 'Update Produk',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
