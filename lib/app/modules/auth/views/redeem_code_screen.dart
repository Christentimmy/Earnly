import 'package:earnly/app/controllers/invite_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RedeemCodeScreen extends StatelessWidget {
  RedeemCodeScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final inviteController = Get.find<InviteController>();
  final redeemCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // title: Text(
        //   'Redeem Code',
        //   style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        // ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter your redeem code',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  hintText: 'Enter redeem code',
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: redeemCodeController,
                  validator: (value) {
                    if (value!.length < 6) {
                      return 'Please enter a valid redeem code';
                    }
                    if (value.isEmpty) {
                      return 'Please enter a redeem code';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                ontap: () async {
                  if (!formKey.currentState!.validate()) return;
                  final code = redeemCodeController.text.trim();
                  await inviteController.redeemInvite(inviteCode: code);
                },
                isLoading: inviteController.isloading,
                child: Text(
                  'Redeem',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.bottomNavigationScreen);
                },
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
