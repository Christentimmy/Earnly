import 'dart:convert';

import 'package:earnly/app/controllers/storage_controller.dart';
import 'package:earnly/app/data/services/auth_service.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  final isloading = false.obs;
  final isOtpVerifyLoading = false.obs;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isloading.value = true;
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
      Get.toNamed(AppRoutes.otpScreen, arguments: {"email": email});
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> login({required String email, required String password}) async {
    isloading.value = true;
    try {
      final response = await authService.login(
        email: email,
        password: password,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      final message = decoded["message"];
      if (response.statusCode == 402) {
        Get.toNamed(
          AppRoutes.otpScreen,
          arguments: {
            "email": email,
            "whatNext": () => Get.offAllNamed(AppRoutes.bottomNavigationScreen),
          },
        );
      }
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorToast(message);
        return;
      }
      final token = decoded["token"];
      final storageController = Get.find<StorageController>();
      await storageController.storeToken(token);
      Get.offAllNamed(AppRoutes.bottomNavigationScreen);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> sendOtp({required String email}) async {
    isloading.value = true;
    try {
      final response = await authService.sendOtp(email: email);
      if (response == null) return;

      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorToast(message);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
    VoidCallback? whatNext,
  }) async {
    isOtpVerifyLoading.value = true;
    try {
      final response = await authService.verifyOtp(email: email, otp: otp);
      if (response == null) return;

      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorToast(message);
        return;
      }

      if (whatNext != null) {
        whatNext();
        return;
      }

      Get.toNamed(AppRoutes.homeScreen);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isOtpVerifyLoading.value = false;
    }
  }

  Future<void> validateToken({required String token}) async {
    try {
      final response = await authService.validateToken(token: token);
      if (response == null) {
        Get.offAllNamed(AppRoutes.welcomeScreen);
        return;
      }
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      String email = decoded["email"];
      if (response.statusCode == 405) {
        Get.offAllNamed(
          AppRoutes.otpScreen,
          arguments: {
            "email": email,
            "whatNext": () => Get.offAllNamed(AppRoutes.bottomNavigationScreen),
          },
        );
        return;
      }
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorToast(message);
        Get.offAllNamed(AppRoutes.welcomeScreen);
        return;
      }
      Get.offAllNamed(AppRoutes.bottomNavigationScreen);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
