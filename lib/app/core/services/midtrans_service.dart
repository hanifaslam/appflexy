import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptiket/app/models/midtrans_transaction.dart';
import 'package:apptiket/app/core/constants/api_constants.dart';
import 'package:flutter/foundation.dart';

class MidtransService {  // Base URL for backend API
  // Use ApiConstants to ensure URL consistency throughout the app
  String get apiUrl {
    return ApiConstants.getFullUrl(ApiConstants.transaction);
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
      );      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (kDebugMode) {
          print('Success response from Midtrans: $data');
        }
        return MidtransTokenResponse.fromJson(data);
      } else {
        if (kDebugMode) {
          print('Error from Midtrans API - Status code: ${response.statusCode}');
          print('Error response body: ${response.body}');
          print('Request URL was: $apiUrl');
        }
        throw Exception('Failed to get Midtrans token: ${response.statusCode}. Ensure your backend endpoint is configured correctly.');
      }    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to server: $e');
        print('API URL attempted: $apiUrl');
        print('Ensure your emulator/device can reach the server at: ${ApiConstants.baseUrl}');
      }
      throw Exception('Error connecting to Midtrans server: $e. Check your network connection and server configuration.');
    }
  }

  // Get full URL for Midtrans Snap
  String getSnapUrl(String token) {
    return '$snapUrl$token';
  }
}
