import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/data/models/notik_task_model.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class NotikTaskScreen extends StatefulWidget {
  const NotikTaskScreen({super.key});

  @override
  State<NotikTaskScreen> createState() => _NotikTaskScreenState();
}

class _NotikTaskScreenState extends State<NotikTaskScreen> {
  final earnController = Get.find<EarnController>();
  final scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (earnController.notikTaskList.isNotEmpty) return;
      earnController.getNotikAds();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !earnController.isloading.value) {
        earnController.getNotikAds(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    earnController.isloading.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Tasks Hub',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (earnController.notikTaskList.isEmpty &&
                    earnController.isloading.value) {
                  return Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(color: Colors.white),
                    ),
                  );
                }
                if (earnController.notikTaskList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No Task Found',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    itemCount: earnController.notikTaskList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final task = earnController.notikTaskList[index];
                      return TaskCard(taskModel: task);
                    },
                  ),
                );
              }),
              Obx(() {
                if (earnController.notikTaskList.isNotEmpty &&
                    earnController.isloading.value) {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: CupertinoActivityIndicator(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final NotikTaskModel taskModel;

  const TaskCard({super.key, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            AppRoutes.notikTaskDetailsScreen,
            arguments: {'task': taskModel},
          ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Game Image with Gradient Overlay
              Image.network(
                taskModel.imageUrl ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.7),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: AppColors.primaryColor,
                    highlightColor: AppColors.accentGreen,
                    child: Container(color: AppColors.primaryColor),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),

              // Content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      taskModel.name!.length > 20
                          ? "${taskModel.name!.substring(0, 20)}..."
                          : taskModel.name ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      taskModel.description1!.length > 30
                          ? "${taskModel.description1!.substring(0, 30)}..."
                          : taskModel.description1 ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
