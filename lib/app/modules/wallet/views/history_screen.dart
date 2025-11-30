import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/modules/wallet/widgets/build_transaction_item.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final userController = Get.find<UserController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.withdrawHistory.isNotEmpty) return;
      userController.getWithdrawHistory();
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!userController.isloading.value && userController.hasNextPage.value) {
          userController.getWithdrawHistory(loadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundColor,
              const Color(0xFF0F2410),
              AppColors.backgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (userController.withdrawHistory.isEmpty) {
                    return Center(child: Text("Empty"));
                  }
                  return RefreshIndicator(
                    onRefresh: () => userController.getWithdrawHistory(showLoder: false),
                    color: AppColors.primaryColor,
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: userController.withdrawHistory.length,
                      itemBuilder: (context, index) {
                        final withdraw = userController.withdrawHistory[index];
                        return buildTransactionItem(withdraw: withdraw);
                      },
                    ),
                  );
                }),
              ),
              Obx(() {
                if (userController.isloading.value) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      color: AppColors.accentGreen,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: ShaderMask(
        shaderCallback:
            (bounds) => LinearGradient(
              colors: [AppColors.lightGreen, AppColors.accentGreen],
            ).createShader(bounds),
        child: Text(
          'History',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
