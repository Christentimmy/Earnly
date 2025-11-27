import 'dart:convert';

import 'package:earnly/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EarnService {
  Future<http.Response?> claimWheelSpin({
    required String token,
    required int reward,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/earn/claim-wheel-spin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'reward': reward}),
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> dice({
    required String token,
    required double stake,
    required double balance,
    required bool win,
    required double amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/earn/dice'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'stake': stake,
          'balance': balance,
          'win': win,
          'amount': amount,
        }),
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> getWheelSpinRewards({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/earn/get-wheel-spin-rewards'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
