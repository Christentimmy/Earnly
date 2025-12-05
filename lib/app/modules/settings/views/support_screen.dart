import 'dart:io';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/utils/image_picker.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/custom_textfield.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({super.key});

  final RxList<File> selectedMedias = <File>[].obs;
  final userController = Get.find<UserController>();

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: ListView(
            children: [
              SizedBox(height: Get.height * 0.02),
              Text(
                "Topic",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              CustomTextField(
                hintText: "Enter topic name",
                controller: subjectController,
                textStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Message",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              CustomTextField(
                hintText: "Enter your message",
                minLines: 5,
                maxLines: 6,
                controller: messageController,
                textStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final attachments = await pickNoCompressedImages();
                  if (attachments != null) {
                    selectedMedias.addAll(attachments);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.image,
                        color: AppColors.primaryColor,
                        size: 40,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Browse images or drop here",
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "JPG, PNG , file size no more than 25MB",
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              _buildSelectedMedia(),
              SizedBox(height: Get.height * 0.1),
              CustomButton(
                loaderColor: Colors.white,
                ontap: () async {
                  if (selectedMedias.isEmpty) {
                    CustomSnackbar.showErrorToast(
                      "Please select at least one image",
                    );
                    return;
                  }
                  if (selectedMedias.length > 5) {
                    CustomSnackbar.showErrorToast(
                      "You can select maximum 5 images",
                    );
                    return;
                  }
                  if (subjectController.text.isEmpty) {
                    CustomSnackbar.showErrorToast("Please enter a subject");
                    return;
                  }
                  if (messageController.text.isEmpty) {
                    CustomSnackbar.showErrorToast("Please enter a message");
                    return;
                  }
                  await userController.createTicket(
                    attachments: selectedMedias,
                    subject: subjectController.text,
                    description: messageController.text,
                  );
                },
                isLoading: userController.isloading,
                child: Text(
                  "Create",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedMedia() {
    return Obx(() {
      if (selectedMedias.isEmpty) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        height: Get.height * 0.08,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: selectedMedias.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final media = selectedMedias[index];
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: Get.width * 0.18,
                  height: Get.height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(media, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      selectedMedias.removeAt(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Get Help",
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: InkWell(
          onTap: () => Get.back(),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
      leadingWidth: 45,
    );
  }
}
