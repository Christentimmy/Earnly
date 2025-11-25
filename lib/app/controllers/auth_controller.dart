import 'dart:convert';

import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/data/services/auth_service.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await authService.register(
        name: name,
        email: email,
        password: password,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      final message = decoded["message"];
      if (response.statusCode != 201) {
        CustomSnackbar.showErrorToast(message);
        return;
      }
      final token = decoded["token"];
      final storageController = Get.find<StorageController>();
      await storageController.storeToken(token);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
