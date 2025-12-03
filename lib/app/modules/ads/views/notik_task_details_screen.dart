import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/data/models/notik_task_model.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/utils/url_launcher.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotikTaskDetailScreen extends StatefulWidget {
  final NotikTaskModel taskModel;

  const NotikTaskDetailScreen({super.key, required this.taskModel});

  @override
  State<NotikTaskDetailScreen> createState() => _NotikTaskDetailScreenState();
}

class _NotikTaskDetailScreenState extends State<NotikTaskDetailScreen> {
  final earnController = Get.find<EarnController>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (earnController.exchangeRate.value != 0) return;
      earnController.getExchangeRate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Task Image
                  Image.network(
                    widget.taskModel.imageUrl ?? "",
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: AppColors.darkGreen,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.backgroundColor.withValues(alpha: 0.7),
                          AppColors.backgroundColor,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Name
                  Text(
                    widget.taskModel.name ?? "Task Name",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payout Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accentGreen, AppColors.lightGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGreen.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Earn Reward',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.backgroundColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Obx(() {
                              final exchange =
                                  earnController.exchangeRate.value;
                              final payout = widget.taskModel.payout ?? 0.0;
                              final price = payout / exchange;
                              return Text(
                                price.toStringAsFixed(3),
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.backgroundColor,
                                ),
                              );
                            }),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/logo_1.png',
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Description Section
                  if (widget.taskModel.description1?.isNotEmpty ?? false) ...[
                    _SectionTitle(title: 'About This Task'),
                    const SizedBox(height: 12),
                    _DescriptionCard(text: widget.taskModel.description1!),
                    const SizedBox(height: 16),
                  ],

                  if (widget.taskModel.description2?.isNotEmpty ?? false) ...[
                    _DescriptionCard(text: widget.taskModel.description2!),
                    const SizedBox(height: 16),
                  ],

                  if (widget.taskModel.description3?.isNotEmpty ?? false) ...[
                    _DescriptionCard(text: widget.taskModel.description3!),
                    const SizedBox(height: 30),
                  ],

                  // Events Section
                  if (widget.taskModel.events?.isNotEmpty ?? false) ...[
                    _SectionTitle(title: 'Task Milestones'),
                    const SizedBox(height: 12),
                    ...List.generate(
                      widget.taskModel.events!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _EventCard(
                          event: widget.taskModel.events![index],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // Task Details Grid
                  _SectionTitle(title: 'Task Details'),
                  const SizedBox(height: 12),

                  // Categories
                  if (widget.taskModel.categories?.isNotEmpty ?? false)
                    _DetailRow(
                      icon: Icons.category_outlined,
                      label: 'Categories',
                      value: widget.taskModel.categories!.join(', '),
                    ),

                  // Platforms
                  if (widget.taskModel.platforms?.isNotEmpty ?? false)
                    _DetailRow(
                      icon: Icons.devices_outlined,
                      label: 'Platforms',
                      value: widget.taskModel.platforms!.join(', '),
                    ),

                  // OS
                  if (widget.taskModel.os?.isNotEmpty ?? false)
                    _DetailRow(
                      icon: Icons.phone_android_outlined,
                      label: 'Operating Systems',
                      value: widget.taskModel.os!.join(', '),
                    ),

                  // Countries
                  if (widget.taskModel.countryCode?.isNotEmpty ?? false)
                    _DetailRow(
                      icon: Icons.public_outlined,
                      label: 'Available Countries',
                      value: widget.taskModel.countryCode!.join(', '),
                    ),

                  const SizedBox(height: 40),

                  // Start Task Button
                  CustomButton(
                    ontap: () async {
                      HapticFeedback.lightImpact();
                      String? url = widget.taskModel.clickUrl;
                      if (url == null || url.isEmpty) {
                        CustomSnackbar.showErrorToast("Url is missing");
                        return;
                      }
                      final userId = userController.userModel.value?.id ?? "";
                      final fixedUrl = url.replaceFirst('[user_id]', userId);
                      await urlLauncher(fixedUrl.toString());
                    },
                    isLoading: false.obs,
                    bgColor: AppColors.accentGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGreen.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Start Task',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Section Title Widget
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

// Description Card Widget
class _DescriptionCard extends StatelessWidget {
  final String text;

  const _DescriptionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGreen.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white.withOpacity(0.9),
          height: 1.6,
        ),
      ),
    );
  }
}

// Event Card Widget
class _EventCard extends StatelessWidget {
  final Event event;
  _EventCard({required this.event});

  final earnController = Get.find<EarnController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkGreen.withValues(alpha: 0.6),
            AppColors.darkGreen.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.accentGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name ?? "Event",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(() {
                  final exchange = earnController.exchangeRate.value;
                  final payout = event.payout ?? 0.0;
                  final price = payout / exchange;
                  return Text(
                    'Reward: ${price.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightGreen,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkGreen.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.accentGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
