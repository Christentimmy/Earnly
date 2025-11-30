import 'dart:convert';
import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/data/models/user_model.dart';
import 'package:earnly/app/data/models/withdraw_model.dart';
import 'package:earnly/app/data/services/user_service.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserController extends GetxController {
  final UserService userService = UserService();
  final Rxn<UserModel> userModel = Rxn<UserModel>();
  final isloading = false.obs;
  final RxList<WithdrawModel> withdrawHistory = RxList<WithdrawModel>();

  final currentPage = 1.obs;
  final hasNextPage = false.obs;

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
    String? memo,
    required String network,
    required String address,
    required String amount,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      final response = await userService.createWithdrawalRequest(
        token: token,
        network: network,
        address: address,
        amount: amount,
        memo: memo,
      );
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"] ?? "";

      if (response.statusCode != 201) {
        debugPrint(message);
        CustomSnackbar.showErrorToast(message);
        return;
      }
      Get.back();
      getWithdrawHistory();
      getUserDetails();
      _showSuccessDialog();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.darkGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.accentGreen.withOpacity(0.3)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppColors.accentGreen,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Withdrawal Submitted!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your withdrawal request has been submitted successfully. You will receive your funds within 24-48 hours.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> getWithdrawHistory({
    bool showLoder = true,
    bool loadMore = false,
  }) async {
    isloading.value = showLoder;
    try {
      final storageController = Get.find<StorageController>();
      final token = await storageController.getToken();
      if (token == null) return;

      if (loadMore && hasNextPage.value) {
        currentPage.value++;
      }

      final response = await userService.getWithdrawHistory(
        token: token,
        page: currentPage.value,
      );
      if (response == null) return;

      final decoded = json.decode(response.body);
      final message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      final data = decoded["data"];
      if (data == null) return;
      List<WithdrawModel> raw =
          (data as List).map((e) => WithdrawModel.fromJson(e)).toList();
      if (loadMore) {
        withdrawHistory.addAll(raw);
      } else {
        withdrawHistory.value = raw;
      }
      hasNextPage.value = decoded["hasNextPage"] as bool;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
