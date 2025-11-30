import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final userController = Get.find<UserController>();
  final earnController = Get.find<EarnController>();

  @override
  void initState() {
    super.initState();
    earnController.getExchangeRate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (earnController.exchangeRate.value != 0) return;
      earnController.getExchangeRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildBalanceCard(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildTransactionHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [AppColors.lightGreen, AppColors.accentGreen],
                  ).createShader(bounds),
              child: Text(
                'Your Wallet',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your rewards',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accentGreen.withOpacity(0.2),
                AppColors.primaryColor.withOpacity(0.2),
              ],
            ),
            border: Border.all(
              color: AppColors.accentGreen.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.accentGreen,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            const Color(0xFF1a3a1f),
            AppColors.darkGreen,
          ],
        ),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Total Points Balance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [Colors.white, AppColors.lightGreen],
                ).createShader(bounds),
            child: Obx(() {
              final points = userController.userModel.value?.credits ?? 0;
              return Text(
                points.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                ),
                // points.toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -2,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentGreen.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppColors.accentGreen,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'USD Value',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final points = userController.userModel.value?.credits ?? 0;
                  final exR = earnController.exchangeRate.value;
                  final usdEquivalent = (points * exR).toStringAsFixed(10);
                  return Text(
                    '\$$usdEquivalent',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Withdraw',
            Icons.send_rounded,
            [AppColors.accentGreen, const Color(0xFF059669)],
            AppColors.accentGreen,
            true,
            () => Get.toNamed(AppRoutes.withdrawScreen),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            'History',
            Icons.history_rounded,
            [
              AppColors.primaryColor.withValues(alpha: 0.5),
              AppColors.darkGreen.withValues(alpha: 0.5),
            ],
            AppColors.lightGreen,
            false,
            () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    List<Color> gradientColors,
    Color iconColor,
    bool isPrimary,
    VoidCallback? onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            border: Border.all(
              color:
                  isPrimary
                      ? AppColors.accentGreen.withOpacity(0.2)
                      : AppColors.accentGreen.withOpacity(0.2),
              width: 1,
            ),
            boxShadow:
                isPrimary
                    ? [
                      BoxShadow(
                        color: AppColors.accentGreen.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                    : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    final transactions = [
      {
        'type': 'earn',
        'amount': 250,
        'desc': 'Video Ad Completed',
        'time': '2 hours ago',
        'icon': Icons.card_giftcard,
      },
      {
        'type': 'earn',
        'amount': 180,
        'desc': 'Survey Completed',
        'time': '5 hours ago',
        'icon': Icons.bolt,
      },
      {
        'type': 'withdraw',
        'amount': -500,
        'desc': 'BTC Withdrawal',
        'time': '1 day ago',
        'icon': Icons.currency_bitcoin,
      },
      {
        'type': 'earn',
        'amount': 320,
        'desc': 'Referral Bonus',
        'time': '2 days ago',
        'icon': Icons.people,
      },
      {
        'type': 'earn',
        'amount': 150,
        'desc': 'Daily Login Streak',
        'time': '2 days ago',
        'icon': Icons.shield,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: AppColors.accentGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...transactions
            .map(
              (tx) => _buildTransactionItem(
                tx['desc'] as String,
                tx['time'] as String,
                tx['amount'] as int,
                tx['icon'] as IconData,
                tx['type'] as String == 'earn',
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildTransactionItem(
    String description,
    String time,
    int amount,
    IconData icon,
    bool isPositive,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentGreen.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  isPositive
                      ? AppColors.accentGreen.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isPositive ? AppColors.accentGreen : Colors.red[400],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}$amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isPositive ? AppColors.accentGreen : Colors.red[400],
            ),
          ),
        ],
      ),
    );
  }
}
