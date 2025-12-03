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
          'stake': stake.toStringAsFixed(2),
          'balance': balance.toStringAsFixed(2),
          'win': win,
          'amount': amount.toStringAsFixed(2),
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

  Future<http.Response?> getAd({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/earn/get-ad'),
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

  Future<http.Response?> completedAd({required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/earn/completed-ad'),
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

  Future<http.Response?> earnHistory({required String token, int? page}) async {
    try {
      String url = "$baseUrl/earn/earn-history";
      if (page != null) {
        url += "?page=$page";
      }
      final response = await http.get(
        Uri.parse(url),
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

  Future<http.Response?> getExchangeRate({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/earn/exchange-rate'),
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

  Future<http.Response?> getNotikAds({required String token, String? nextPageUrl}) async {
    try {
      String url = "$baseUrl/earn/notik-ads";
      if (nextPageUrl != null) {
        url += "?nextPageUrl=$nextPageUrl";
      }
      final response = await http.get(
        Uri.parse(url),
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
