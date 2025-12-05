import 'package:earnly/app/controllers/invite_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/data/models/invite_model.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/loaders.dart';
import 'package:earnly/app/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class InviteStatsScreen extends StatefulWidget {
  const InviteStatsScreen({super.key});

  static Widget _buildStatBubble({
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  State<InviteStatsScreen> createState() => _InviteStatsScreenState();
}

class _InviteStatsScreenState extends State<InviteStatsScreen> {
  final userController = Get.find<UserController>();
  final inviteController = Get.find<InviteController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.userModel.value?.inviteCode?.isEmpty == true) {
        inviteController.getMyInviteCode();
      }
      inviteController.getInviteStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: buildAppBar(),
      body: Obx(() {
        if (inviteController.isloading.value) {
          return buildLoader();
        }
        return buildContent();
      }),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: Colors.white,
      title: Text(
        'Invitation Statistics',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      centerTitle: true,
    );
  }

  Widget buildLoader() {
    return Center(child: Loader2());
  }

  Widget buildContent() {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        inviteController.getInviteStats();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildContentCotainerHeader(),
            const SizedBox(height: 24),
            buildCodeCard(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Recent Invites',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Obx(() {
                    final inviteModel = inviteController.inviteModel.value;
                    if (inviteModel == null) return const SizedBox();
                    return Text(
                      '${inviteModel.totalInvites} total',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Obx(() {
              final inviteModel = inviteController.inviteModel.value;
              if (inviteModel == null) return const SizedBox();
              if (inviteModel.recentInvites!.isEmpty) {
                return buildEmptyRecentInvite();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: inviteModel.recentInvites!.length,
                itemBuilder: (context, index) {
                  final invite = inviteModel.recentInvites![index];
                  return buildRecentInviteCard(invite);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Card buildRecentInviteCard(RecentInvites invite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor.withOpacity(0.15),
          child: Text(
            invite.displayName!.substring(0, 1),
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          invite.displayName!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          DateFormat("MMM dd, yyyy").format(invite.redeemedAt!),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '+${invite.rewardGiven} credits',
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Column buildEmptyRecentInvite() {
    return Column(
      children: [
        Icon(Icons.people_outline_rounded, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(
          'No invites yet',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start inviting friends to earn rewards!',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Card buildCodeCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                color: AppColors.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Code',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final inviteModel = inviteController.inviteModel.value;
                    if (inviteModel == null) return const SizedBox();
                    return Text(
                      inviteModel.myInviteCode ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: AppColors.primaryColor,
                      ),
                    );
                  }),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                final inviteModel = inviteController.inviteModel.value;
                if (inviteModel == null) return;
                await Clipboard.setData(
                  ClipboardData(text: inviteModel.myInviteCode!),
                );
                CustomSnackbar.showSuccessToast("Copied to clipboard");
              },
              icon: const Icon(Icons.copy),
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Container buildContentCotainerHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        children: [
          const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 60),
          const SizedBox(height: 16),
          const Text(
            'Your Impact',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            final inviteModel = inviteController.inviteModel.value;
            if (inviteModel == null) return const SizedBox();
            return InviteStatsScreen._buildStatBubble(
              value: inviteModel.totalInvites.toString(),
              label: 'Total Invites',
            );
          }),
        ],
      ),
    );
  }
}
