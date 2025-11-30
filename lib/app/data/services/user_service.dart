import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:earnly/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<http.Response?> getUserDetails({required String token}) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/user/user-details"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> createWithdrawalRequest({
    required String token,
    required String network,
    required String address,
    required String amount,
    String? memo,
  }) async {
    Map body = {
      "amount": amount,
      "paymentDetails": {"network": network, "walletAddress": address},
    };
    if (memo != null) body['memo'] = memo;
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/user/create-withdrawal-request"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
