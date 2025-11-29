import 'dart:convert';
import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/data/models/user_model.dart';
import 'package:earnly/app/data/services/user_service.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService userService = UserService();
  final Rxn<UserModel> userModel = Rxn<UserModel>();

  Future<void> getUserDetails() async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await userService.getUserDetails(token: token);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"] ?? "";

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      final data = decoded["data"];
      if (data == null) return;
      final user = UserModel.fromJson(data);
      userModel.value = user;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> createWithdrawalRequest({
    required String network,
    required String address,
    required String amount,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await userService.createWithdrawalRequest(
        token: token,
        network: network,
        address: address,
        amount: amount,
      );
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"] ?? "";

      if (response.statusCode != 201) {
        debugPrint(message);
        CustomSnackbar.showErrorToast(message);
        return;
      }
      CustomSnackbar.showSuccessToast(message);
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
