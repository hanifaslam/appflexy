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
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(res.wp(5)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(res.wp(12)),
                child: Container(
                  height: res.wp(55),
                  width: res.wp(55),
                  child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    child: Image.asset("assets/logo/lupa.png"),
                  ),
                ),
              ),
              SizedBox(height: res.hp(2)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Obx(() => TextField(
                      controller: controller.passwordLamaController,
                      onChanged: (value) =>
                          controller.passwordLama.value = value,
                      obscureText: !controller.isPasswordLamaVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Password Saat Ini',
                        prefixIcon: Icon(Icons.lock, color: Color(0xff181681)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordLamaVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff181681),
                          ),
                          onPressed: controller.togglePasswordLamaVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(2.5)),
                          borderSide:
                              BorderSide(color: Color(0xff181681), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3.5)),
                          borderSide:
                              BorderSide(color: Color(0xff181681), width: 0.5),
                        ),
                      ),
                      style: TextStyle(fontSize: res.sp(16)),
                    )),
              ),
              SizedBox(height: res.hp(2)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Obx(() => TextField(
                      controller: controller.passwordBaruController,
                      onChanged: (value) =>
                          controller.passwordBaru.value = value,
                      obscureText: !controller.isPasswordBaruVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Password Baru',
                        prefixIcon: Icon(Icons.lock, color: Color(0xff181681)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordBaruVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff181681),
                          ),
                          onPressed: controller.togglePasswordBaruVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(2.5)),
                          borderSide:
                              BorderSide(color: Color(0xff181681), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3.5)),
                          borderSide:
                              BorderSide(color: Color(0xff181681), width: 0.5),
                        ),
                      ),
                      style: TextStyle(fontSize: res.sp(16)),
                    )),
              ),
              SizedBox(height: res.hp(2)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Obx(() => TextField(
                      controller: controller.confirmPasswordController,
                      onChanged: (value) =>
                          controller.confirmPassword.value = value,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Konfirmasi Password Baru',
                        prefixIcon: Icon(Icons.lock, color: Color(0xff181681)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xff181681),
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(2.5)),
                          borderSide:
                              BorderSide(color: Color(0xff181681), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(res.wp(3.5)),
                          borderSide:
                              BorderSide(color: Color(0xff181681), width: 0.5),
                        ),
                      ),
                      style: TextStyle(fontSize: res.sp(16)),
                    )),
              ),
              SizedBox(height: res.hp(4)),
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff181681),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: res.wp(8), vertical: res.hp(2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(res.wp(2)),
                      ),
                      elevation: 4,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.gantiPassword,
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Ganti Password",
                            style: TextStyle(fontSize: res.sp(16)),
                          ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
