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

  Future<http.Response?> getWithdrawHistory({
    required String token,
    required int page,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/user/withdraw-history?page=$page"),
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

  Future<http.Response?> createTicket({
    required String token,
    required List<File> attachments,
    required String subject,
    required String description,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/support-ticket/create-ticket");
      final requests = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = 'Bearer $token';
      final files = await Future.wait(
        attachments
            .map((e) => http.MultipartFile.fromPath('attachments', e.path))
            .toList(),
      );
      requests.files.addAll(files);
      requests.fields['subject'] = subject;
      requests.fields['description'] = description;
      final response = await requests.send().timeout(
        const Duration(seconds: 60),
      );
      return await http.Response.fromStream(response);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> editProfile({
    required String token,
    required String name,
    required String email,
  }) async {
    print("name $name");
    print("email $email");
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/user/edit-profile"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"name": name, "email": email}),
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
