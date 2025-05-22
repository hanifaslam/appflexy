import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptiket/app/models/midtrans_transaction.dart';
import 'package:flutter/foundation.dart';

class MidtransService {
  // Base URL for backend API
  // 10.0.2.2 is used for Android emulator to connect to host machine's localhost
  // If running on a physical device, you might need to use the actual IP address
  String get apiUrl {
    // For physical devices, use a more accessible IP or domain
    if (kDebugMode) {
      // If we're in debug mode and potentially on an emulator
      return 'http://10.0.2.2:8000/api/transaction';
    } else {
      // For production or physical device testing
      return 'http://flexy.my.id/api/transaction';
    }
  }

  // Midtrans Client Key
  final String clientKey = 'Mid-client-z6sUpBtZ9dzSV5Vk';

  // Midtrans Snap URL
  final String snapUrl = 'https://app.sandbox.midtrans.com/snap/v2/vtweb/';

  // Method to get Midtrans Snap token from backend
  Future<MidtransTokenResponse> getSnapToken(
      MidtransTransaction transaction) async {
    try {
      if (kDebugMode) {
        print('Sending transaction to: $apiUrl');
        print('Transaction data: ${transaction.toJson()}');
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (kDebugMode) {
          print('Response: $data');
        }
        return MidtransTokenResponse.fromJson(data);
      } else {
        if (kDebugMode) {
          print('Error response: ${response.body}');
        }
        throw Exception('Failed to get Midtrans token: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to server: $e');
      }
      throw Exception('Error connecting to server: $e');
    }
  }

  // Get full URL for Midtrans Snap
  String getSnapUrl(String token) {
    return '$snapUrl$token';
  }
}
