import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/custom_textfield.dart';
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
          children: [
            SizedBox(height: Get.height * 0.15),
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
              ontap: () async {},
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
