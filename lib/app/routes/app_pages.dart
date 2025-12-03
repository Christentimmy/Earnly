import 'package:earnly/app/data/models/notik_task_model.dart';
import 'package:earnly/app/modules/ads/views/notik_task_details_screen.dart';
import 'package:earnly/app/modules/ads/views/notik_task_screen.dart';
import 'package:earnly/app/modules/ads/views/watch_ads_screen.dart';
import 'package:earnly/app/modules/auth/views/otp_screen.dart';
import 'package:earnly/app/modules/auth/views/forget_password_screen.dart';
import 'package:earnly/app/modules/auth/views/login_screen.dart';
import 'package:earnly/app/modules/auth/views/register_screen.dart';
import 'package:earnly/app/modules/auth/views/reset_password_screen.dart';
import 'package:earnly/app/modules/games/views/dice_game_screen.dart';
import 'package:earnly/app/modules/games/views/game_screen.dart';
import 'package:earnly/app/modules/games/views/wheel_spin_screen.dart';
import 'package:earnly/app/modules/home/views/home_screen.dart';
import 'package:earnly/app/modules/onboarding/views/onboarding_screen_1.dart';
import 'package:earnly/app/modules/onboarding/views/onboarding_screen_2.dart';
import 'package:earnly/app/modules/onboarding/views/welcome_screen.dart';
import 'package:earnly/app/modules/splash/views/splash_screen.dart';
import 'package:earnly/app/modules/wallet/views/history_screen.dart';
import 'package:earnly/app/modules/wallet/views/wallet_screen.dart';
import 'package:earnly/app/modules/wallet/views/withdraw_screen.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.onboardingScreen1,
      page: () => const OnboardingScreen1(),
    ),
    GetPage(
      name: AppRoutes.onboardingScreen2,
      page: () => const OnboardingScreen2(),
    ),
    GetPage(name: AppRoutes.welcomeScreen, page: () => const WelcomeScreen()),
    GetPage(name: AppRoutes.loginScreen, page: () => LoginScreen()),
    GetPage(name: AppRoutes.registerScreen, page: () => RegisterScreen()),
    GetPage(
      name: AppRoutes.forgetPasswordScreen,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () {
        final arguments = Get.arguments ?? {};
        final email = arguments['email'] as String;
        if (email.isEmpty) {
          throw Exception('Email is required');
        }
        final whatNext = arguments['whatNext'] as VoidCallback?;
        return OtpScreen(email: email, whatNext: whatNext);
      },
    ),
    GetPage(name: AppRoutes.homeScreen, page: () => HomeScreen()),
    GetPage(name: AppRoutes.gameScreen, page: () => GameScreen()),
    GetPage(name: AppRoutes.walletScreen, page: () => const WalletScreen()),
    // GetPage(name: AppRoutes.settingsScreen, page: () => const SettingsScreen()),
    GetPage(
      name: AppRoutes.bottomNavigationScreen,
      page: () => const FloatingBottomNavigationWidget(),
    ),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.wheelSpinScreen, page: () => WheelSpinScreen()),
    GetPage(name: AppRoutes.diceGameScreen, page: () => DiceGameScreen()),
    GetPage(
      name: AppRoutes.watchAd,
      page: () {
        final arguments = Get.arguments ?? {};
        final url = arguments['url'] as String;
        if (url.isEmpty) {
          throw Exception('Url is required');
        }
        return WatchAdsScreen(url: url);
      },
    ),
    GetPage(name: AppRoutes.withdrawScreen, page: () => const WithdrawScreen()),
    GetPage(name: AppRoutes.historyScreen, page: () => HistoryScreen()),
    GetPage(name: AppRoutes.resetPasswordScreen, page: (){
      final arguments = Get.arguments ?? {};
      final email = arguments['email'] as String;
      if (email.isEmpty) {
        throw Exception('Email is required');
      }
      return ResetPasswordScreen(email: email);
    }),
    GetPage(name: AppRoutes.notikTaskScreen, page: () => NotikTaskScreen()),
    GetPage(name: AppRoutes.notikTaskDetailsScreen, page: (){
      final arguments = Get.arguments ?? {};
      final task = arguments['task'] as NotikTaskModel?;
      if (task == null) {
        throw Exception('Task is required');
      }
      return NotikTaskDetailScreen(taskModel: task);
    }),
  ];
}
