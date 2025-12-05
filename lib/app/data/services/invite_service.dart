import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:earnly/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InviteService {
  
  Future<http.Response?> getMyInviteCode({required String token}) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/invitations/my-code"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          )
          .timeout(const Duration(seconds: 10));
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

  Future<http.Response?> getInviteStats({required String token}) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/invitations/stats"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          )
          .timeout(const Duration(seconds: 15));
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

  Future<http.Response?> redeemInvite({
    required String token,
    required String inviteCode,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/invitations/redeem"),
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
            body: json.encode({"inviteCode": inviteCode}),
          )
          .timeout(const Duration(seconds: 15));
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
