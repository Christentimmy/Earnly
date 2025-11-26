import 'dart:convert';
import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/data/services/earn_service.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EarnController extends GetxController {
  final EarnService earnService = EarnService();

  final RxList<int> wheelSpinRewards = <int>[].obs;
  @override
  void onInit() {
    super.onInit();
    getWheelSpinRewards();
  }

  Future<void> wheelSpin() async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.wheelSpin(token: token);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      await Get.find<UserController>().getUserDetails();
      CustomSnackbar.showSuccessToast(message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getWheelSpinRewards() async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.getWheelSpinRewards(token: token);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      wheelSpinRewards.value = decoded["data"] ?? [];
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}
