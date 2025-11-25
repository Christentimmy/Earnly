import 'package:earnly/app/modules/auth/views/forget_password_code_screen.dart';
import 'package:earnly/app/modules/auth/views/forget_password_screen.dart';
import 'package:earnly/app/modules/auth/views/login_screen.dart';
import 'package:earnly/app/modules/auth/views/register_screen.dart';
import 'package:earnly/app/modules/home/views/home_screen.dart';
import 'package:earnly/app/modules/onboarding/views/onboarding_screen_1.dart';
import 'package:earnly/app/modules/onboarding/views/onboarding_screen_2.dart';
import 'package:earnly/app/modules/onboarding/views/welcome_screen.dart';
import 'package:earnly/app/routes/app_routes.dart';
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
    GetPage(
      name: AppRoutes.welcomeScreen,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.registerScreen,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.forgetPasswordScreen,
      page: () => const ForgetPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.forgetPasswordCodeScreen,
      page: () => const ForgetPasswordCodeScreen(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
    ),
  ];
}
