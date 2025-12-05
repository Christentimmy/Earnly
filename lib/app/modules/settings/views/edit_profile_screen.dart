import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    usernameController.text = userController.userModel.value?.name ?? "";
    emailController.text = userController.userModel.value?.email ?? "";
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: Get.height * 0.07),
            Text(
              "Email",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Username",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(
              controller: usernameController,
              hintText: "Username",
              keyboardType: TextInputType.name,
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Get.height * 0.3),
            CustomButton(
              ontap: () async {
                final userMod = userController.userModel.value;
                final isNameDiff = userMod?.name != usernameController.text;
                final isEmailDiff = userMod?.email != emailController.text;
                if (!isNameDiff && !isEmailDiff) {
                  CustomSnackbar.showErrorToast("Please change one field");
                  return;
                }
                if (userController.isloading.value) return;
                await userController.editProfile(
                  email: emailController.text,
                  name: usernameController.text,
                );
              },
              isLoading: userController.isloading,
              child: Text(
                "Save",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
