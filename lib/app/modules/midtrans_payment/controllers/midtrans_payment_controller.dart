import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apptiket/app/core/services/midtrans_service.dart';
import 'package:apptiket/app/models/midtrans_transaction.dart';

class MidtransPaymentController extends GetxController {
  final MidtransService _midtransService = MidtransService();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isPaymentComplete = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if we have arguments and automatically start payment if available
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      if (args.containsKey('amount') &&
          args.containsKey('name') &&
          args.containsKey('email')) {
        // Auto-process payment after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          processPayment(
            amount: args['amount'] as int,
            name: args['name'] as String,
            email: args['email'] as String,
          );
        });
      }
    }
  }

  // Process payment with Midtrans QRIS
  Future<void> processPayment({
    required int amount,
    required String name,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Create transaction object
      final transaction = MidtransTransaction(
        amount: amount,
        name: name,
        email: email,
      );

      // Get token from backend
      final response = await _midtransService.getSnapToken(transaction);

      // Get Snap URL
      final snapUrl = _midtransService.getSnapUrl(response.token);

      // Open Snap URL using url_launcher
      await _launchMidtransSnap(snapUrl);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to process payment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Launch URL for Midtrans Snap
  Future<void> _launchMidtransSnap(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }

      // Set payment as complete - in a real app, you would listen for callbacks
      // from the payment gateway to update this status
      Future.delayed(const Duration(seconds: 1), () {
        isPaymentComplete.value = true;
      });
    } catch (e) {
      error.value = 'Could not launch payment page: $e';
      throw Exception('Failed to open payment page: $e');
    }
  }

  // Handle payment completion - this would typically be called from a callback
  void handlePaymentSuccess() {
    Get.snackbar(
      'Pembayaran Berhasil',
      'Terima kasih atas pembayaran Anda',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Handle payment failure
  void handlePaymentFailure(String message) {
    Get.snackbar(
      'Pembayaran Gagal',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
