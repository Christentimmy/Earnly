import 'dart:convert';
import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/data/models/history_model.dart';
import 'package:earnly/app/data/models/notik_task_model.dart';
import 'package:earnly/app/data/services/earn_service.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EarnController extends GetxController {
  final isloading = false.obs;
  final exchangeRate = 0.0.obs;
  final EarnService earnService = EarnService();

  final RxList<int> wheelSpinRewards = <int>[].obs;

  final historyPageIndex = 1.obs;
  final historyHasNextPage = false.obs;
  final RxList<HistoryModel> history = <HistoryModel>[].obs;
  final notikTaskList = <NotikTaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getWheelSpinRewards();
    getEarnHistory();
  }

  Future<void> dice({
    required double stake,
    required double balance,
    required bool win,
    required double amount,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.dice(
        token: token,
        stake: stake,
        balance: balance,
        win: win,
        amount: amount,
      );
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> claimWheelSpin({required int reward}) async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.claimWheelSpin(
        token: token,
        reward: reward,
      );
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      await Get.find<UserController>().getUserDetails();
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
      List<dynamic> data = decoded["data"] ?? [];
      if (data.isEmpty) return;
      List<int> mapped = data.map((e) => e as int).toList();
      wheelSpinRewards.value = mapped;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getEarnHistory({bool loadMore = false}) async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;
      if (loadMore && historyHasNextPage.value) {
        historyPageIndex.value++;
      }

      final response = await earnService.earnHistory(
        token: token,
        page: historyPageIndex.value,
      );
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      List<dynamic> data = decoded["data"] ?? [];
      if (data.isEmpty) return;
      List<HistoryModel> mapped =
          data.map((e) => HistoryModel.fromJson(e)).toList();
      history.value = mapped;
      historyHasNextPage.value = decoded["pagination"]?["hasNextPage"] ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getAd() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.getAd(token: token);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      final data = decoded["data"];
      if (data == null) return;
      Get.toNamed(AppRoutes.watchAd, arguments: {"url": data});
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> completedAd() async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.completedAd(token: token);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      await Get.find<UserController>().getUserDetails();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getExchangeRate() async {
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.getExchangeRate(token: token);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      final data = decoded["data"];
      if (data == null) return;
      exchangeRate.value = double.tryParse(data.toString()) ?? 0.0;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getNotikAds({bool loadMore = false}) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await earnService.getNotikAds(token: token,loadMore: loadMore);
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"];

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      List data = decoded["data"] ?? [];
      if (data.isEmpty) return;
      List<NotikTaskModel> mapped =
          data.map((e) => NotikTaskModel.fromJson(e)).toList();
      notikTaskList.value = mapped;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
