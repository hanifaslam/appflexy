import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ganti_password_controller.dart';
import 'package:apptiket/app/core/utils/auto_responsive.dart'; // tambahkan import ini

class GantiPasswordView extends StatelessWidget {
  final GantiPasswordController controller = Get.put(GantiPasswordController());

  @override
  Widget build(BuildContext context) {
    final res = AutoResponsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff181681),
        elevation: 1,
        title: Text(
          'Pengaturan Password',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: res.sp(18),
          ),
        ),        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: res.sp(20),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: res.wp(5),
            vertical: res.hp(2),
          ),
          child: Column(
            children: [
              SizedBox(height: res.hp(3)),
              
              // Logo/Image Section
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(res.wp(6)),
                  child: Container(
                    height: res.wp(45),
                    width: res.wp(45),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: res.wp(1),
                          blurRadius: res.wp(3),
                          offset: Offset(0, res.hp(0.5)),
                        ),
                      ],                    ),
                    child: FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      child: Image.asset("assets/logo/lupa.png"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: res.hp(4)),
              
              // Password Lama Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                child: Obx(() => TextField(
                      controller: controller.passwordLamaController,
                      onChanged: (value) =>
                          controller.passwordLama.value = value,
                      obscureText: !controller.isPasswordLamaVisible.value,                      decoration: InputDecoration(
                        hintText: 'Password Saat Ini',
                        hintStyle: TextStyle(
                          fontSize: res.sp(15),
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff181681),
                          size: res.sp(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordLamaVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff181681),
                            size: res.sp(20),
                          ),
                          onPressed: controller.togglePasswordLamaVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: res.wp(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: res.wp(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: res.wp(0.2),
                          ),
                        ),                        contentPadding: EdgeInsets.symmetric(
                          vertical: res.hp(1.8),
                          horizontal: res.wp(4),
                        ),
                      ),
                      style: TextStyle(fontSize: res.sp(16)),
                    )),
              ),
              SizedBox(height: res.hp(2.5)),
              
              // Password Baru Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                child: Obx(() => TextField(
                      controller: controller.passwordBaruController,
                      onChanged: (value) =>
                          controller.passwordBaru.value = value,
                      obscureText: !controller.isPasswordBaruVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Password Baru',
                        hintStyle: TextStyle(
                          fontSize: res.sp(15),
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade700,
                          size: res.sp(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordBaruVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff181681),
                            size: res.sp(20),
                          ),
                          onPressed: controller.togglePasswordBaruVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: res.wp(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: res.wp(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: res.wp(0.2),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: res.hp(1.8),
                          horizontal: res.wp(4),                        ),
                      ),
                      style: TextStyle(fontSize: res.sp(16)),
                    )),
              ),
              SizedBox(height: res.hp(2.5)),
              
              // Confirm Password Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                child: Obx(() => TextField(
                      controller: controller.confirmPasswordController,
                      onChanged: (value) =>
                          controller.confirmPassword.value = value,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Konfirmasi Password Baru',
                        hintStyle: TextStyle(
                          fontSize: res.sp(15),
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade700,
                          size: res.sp(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff181681),
                            size: res.sp(20),
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: res.wp(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: res.wp(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                          borderSide: BorderSide(
                            color: Color(0xff181681),
                            width: res.wp(0.2),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: res.hp(1.8),
                          horizontal: res.wp(4),                        ),
                      ),
                      style: TextStyle(fontSize: res.sp(16)),
                    )),
              ),
              SizedBox(height: res.hp(4)),
              
              // Submit Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: res.wp(2)),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff181681),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: res.wp(8),
                            vertical: res.hp(2.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(res.wp(3)),
                          ),
                          elevation: controller.isLoading.value ? 0 : 3,
                          shadowColor: Color(0xff181681).withOpacity(0.3),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.gantiPassword,
                        child: controller.isLoading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: res.sp(20),
                                    height: res.sp(20),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: res.wp(3)),
                                  Text(
                                    "Mengubah Password...",
                                    style: TextStyle(
                                      fontSize: res.sp(16),
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Ganti Password",
                                style: TextStyle(
                                  fontSize: res.sp(16),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                ),
              ),
              
              SizedBox(height: res.hp(3)),
            ],
          ),
        ),
      ),
    );
  }
}
