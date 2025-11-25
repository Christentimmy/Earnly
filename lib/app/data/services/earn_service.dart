import 'package:earnly/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EarnService {
  Future<http.Response?> wheelSpin({required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/earn/wheel-spin'),
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
