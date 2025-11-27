import "dart:async";
import "dart:convert";
import "dart:io";
import "package:earnly/app/utils/base_url.dart";
import "package:earnly/app/widgets/snack_bar.dart";
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
          .timeout(const Duration(seconds: 30));
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

  Future<http.Response?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/login"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 30));
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

  Future<http.Response?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/verify-otp'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "otp": otp}),
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      CustomSnackbar.showErrorToast("No internet connection");
    } on TimeoutException {
      CustomSnackbar.showErrorToast("Request timeout, please try again");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> sendOtp({required String email}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/send-otp'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email}),
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException {
      CustomSnackbar.showErrorToast("No internet connection");
    } on TimeoutException {
      CustomSnackbar.showErrorToast("Request timeout, please try again");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> validateToken({required String token}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/validate-token'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 30));
      return response;
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } on TimeoutException {
      CustomSnackbar.showErrorToast("Request timeout, please try again");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
