import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_settings_screen.dart';
import 'notification_screen.dart';
import 'security_screen.dart';
import 'invite_friend_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 🔹 Main Scrollable Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🔹 Back Arrow
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔹 Header Title
                  const Text(
                    "Profile settings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Profile Avatar
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white70,
                    child: Text(
                      "CA",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔹 User Info
                  const Text(
                    "Celestial Aria",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "ariaceo15@gmail.com",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 12),

                  // 🔹 Edit Profile Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Edit profile",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // 🔹 Settings Options
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSettingsItem(
                    context,
                    title: "Account",
                    subtitle: "Limits, Currency, Airdrops and more",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: "Notifications",
                    subtitle: "Emails and push alerts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: "Security",
                    subtitle: "Login methods, Backup Phrases and more",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SecurityScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: "Invite friends",
                    subtitle: "Refer your friends for more bonuses",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InviteFriendScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    title: "About app",
                    subtitle: "Support, Policies and more",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutAppScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Sign Out Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.loginScreen);
                    },

                    child: const Text(
                      "Sign out",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),

           
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Widget for Settings Items
  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
          onTap: onTap,
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
