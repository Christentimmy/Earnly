import "dart:async";
import "dart:convert";
import "dart:io";
import "package:earnly/app/utils/base_url.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class AuthService {
  Future<http.Response?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/register"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "name": name,
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 10));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }
}
