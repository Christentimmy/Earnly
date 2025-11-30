import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final userController = Get.find<UserController>();
  final earnController = Get.find<EarnController>();

  String selectedNetwork = 'Bitcoin (BTC)';
  // final int availablePoints = 15847;
  RxDouble estimatedReceive = 0.0.obs;
  RxDouble exchangeRate = 0.0.obs;
  final isValid = false.obs;

  final List<Map<String, dynamic>> networks = [
    {
      'name': 'Bitcoin (BTC)',
      'icon': Icons.currency_bitcoin,
      'color': Colors.orange,
      'fee': 50,
      // 'minWithdraw': 1000,
    },
    {
      'name': 'Ethereum (ETH)',
      'icon': Icons.hexagon,
      'color': Colors.purple,
      'fee': 30,
      // 'minWithdraw': 500,
    },
    {
      'name': 'Coinbase',
      'icon': Icons.account_balance_wallet,
      'color': Colors.blue,
      'fee': 20,
      // 'minWithdraw': 100,
    },
    {
      'name': 'USDT (TRC20)',
      'icon': Icons.toll,
      'color': Colors.green,
      'fee': 10,
      // 'minWithdraw': 100,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _amountController.addListener(_calculateEstimate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (earnController.exchangeRate.value == 0) {
        earnController.getExchangeRate();
      }
      exchangeRate.value = earnController.exchangeRate.value;
    });
  }

  void _calculateEstimate() {
    setState(() {
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      // final network = networks.firstWhere((n) => n['name'] == selectedNetwork);
      // final fee = network['fee'] as int;
      amount = (amount * exchangeRate.value);
      // estimatedReceive.value = amount > fee ? amount - fee : 0;
      estimatedReceive.value = amount;
    });
    isValid.value =
        _addressController.text.isNotEmpty && estimatedReceive.value >= 50;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBalanceCard(),
                        const SizedBox(height: 15),
                        _buildNetworkSelector(),
                        const SizedBox(height: 10),
                        _buildAddressInput(),
                        const SizedBox(height: 15),
                        _buildAmountInput(),
                        const SizedBox(height: 24),
                        _buildSummaryCard(),
                        const SizedBox(height: 32),
                        _buildMemoInput(),
                        const SizedBox(height: 24),
                        _buildWithdrawButton(),
                        const SizedBox(height: 16),
                        _buildInfoCards(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accentGreen.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [AppColors.lightGreen, AppColors.accentGreen],
                    ).createShader(bounds),
                child: const Text(
                  'Withdraw Funds',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Request crypto payout',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.5),
            AppColors.darkGreen.withOpacity(0.3),
          ],
        ),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final availablePoints =
                userController.userModel.value?.credits ?? 0;
            return Text(
              '$availablePoints',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNetworkSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Network',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...networks.map((network) => _buildNetworkOption(network)).toList(),
      ],
    );
  }

  Widget _buildNetworkOption(Map<String, dynamic> network) {
    final isSelected = selectedNetwork == network['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedNetwork = network['name'];
          _calculateEstimate();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.4)
                  : AppColors.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.accentGreen
                    : AppColors.accentGreen.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (network['color'] as Color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(network['icon'], color: network['color'], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    network['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fee: ${network['fee']} pts • Min: ${network['minWithdraw']} pts',
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.accentGreen, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wallet Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
          ),
          child: TextField(
            onChanged: (value) {
              isValid.value = value.isNotEmpty && estimatedReceive.value >= 50;
            },
            cursorColor: AppColors.primaryColor,
            controller: _addressController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your wallet address',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                final availablePoints =
                    userController.userModel.value?.credits ?? 0;
                _amountController.text = availablePoints.toString();
              },
              child: Text(
                'Use Max',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _amountController,
            cursorColor: AppColors.primaryColor,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 24),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'PTS',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Minimum withdrawal: \$50',
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
      ],
    );
  }

  Widget _buildMemoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Memo / Tag',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(Optional)',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _memoController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Add memo or destination tag',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    // final network = networks.firstWhere((n) => n['name'] == selectedNetwork);
    final amount = double.tryParse(_amountController.text) ?? 0;
    // final fee = network['fee'] as int;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentGreen.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.2),
          ],
        ),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Withdrawal Points', '${amount.toInt()} PTS'),
          const SizedBox(height: 12),
          _buildSummaryRow('Network', selectedNetwork, isHighlight: false),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'You will receive',
            '\$${estimatedReceive.toInt()}',
            isHighlight: true,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isHighlight = false,
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            color: isHighlight ? Colors.white : Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 20 : 14,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.accentGreen : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawButton() {
    return Obx(() {
      return CustomButton(
        ontap: () {
          if (!isValid.value) return;
          _showConfirmationDialog();
        },
        isLoading: userController.isloading,
        bgColor: isValid.value ? AppColors.accentGreen : Colors.grey[800]!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              isValid.value ? 'Confirm Withdrawal' : 'Fill Required Fields',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        _buildInfoCard(
          Icons.schedule,
          'Processing Time',
          '24-48 hours on average',
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          Icons.security,
          'Secure Transaction',
          'All withdrawals are encrypted',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.darkGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppColors.accentGreen.withOpacity(0.3)),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.accentGreen),
                const SizedBox(width: 12),
                Text(
                  'Confirm',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please review your withdrawal details:',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                const SizedBox(height: 16),
                _buildDialogRow('Network', selectedNetwork),
                _buildDialogRow('Amount', '${_amountController.text} PTS'),
                _buildDialogRow('You receive', '\$${estimatedReceive.toInt()}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              CustomButton(
                ontap: () async {
                  await userController.createWithdrawalRequest(
                    network: selectedNetwork,
                    address: _addressController.text,
                    amount: _amountController.text,
                    memo: _memoController.text,
                  );
                },
                isLoading: userController.isloading,
                bgColor: AppColors.accentGreen,
                child: Text(
                  'Confirm',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
