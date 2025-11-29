import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/controllers/user_controller.dart';
import 'package:earnly/app/data/models/history_model.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.find<UserController>();
  final earnController = Get.find<EarnController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userController.userModel.value == null) {
        userController.getUserDetails();
      }
      if (earnController.history.isEmpty) {
        earnController.getEarnHistory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 🔹 Scrollable Content (below fixed header)
            Padding(
              padding: const EdgeInsets.only(
                top: 220,
              ), // leaves space for fixed header
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invite Friends Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D3D3D),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Boost +12 Sat/hr with each active referral",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent[400],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 50,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Invite Friends",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Earn Points Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C6BFF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Earn more point by watching Ads",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            ontap: () => earnController.getAd(),
                            isLoading: earnController.isloading,
                            bgColor: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(30),
                            width: Get.width * 0.52,
                            height: 47,
                            loaderColor: AppColors.primaryColor,
                            child: Text(
                              "Earn Points",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Earning History Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Earning History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 0),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // History List
                    // HomeScreen._buildHistoryList(),
                    Obx(() {
                      if (earnController.history.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: earnController.history.length,
                        itemBuilder: (context, index) {
                          final game = earnController.history[index];
                          return _buildHistoryItem(game);
                        },
                      );
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // 🔹 Fixed Profile + Total Earnings Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                // color: const Color(0xFF60D07E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Row
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assets/images/profile.png',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                "${userController.userModel.value?.name}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                "${userController.userModel.value?.email}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Total Earnings Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Earnings",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Obx(
                                () => Text(
                                  "${userController.userModel.value?.credits}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Text(
                                "\$100.46 USD",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Image(
                            image: AssetImage('assets/images/crypto_coins.png'),
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryModel game) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              game.type.contains("win")
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  game.type.contains("win")
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${game.type[0].capitalizeFirst}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTitle(game.type),
                  style: TextStyle(
                    color:
                        game.type.contains("win") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                game.type.contains("dice")
                    ? Text(
                      'Stake: ${game.meta["stake"]}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    )
                    : Text(
                      'Reward: ${game.meta["reward"]}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
              ],
            ),
          ),
          Text(
            game.amount.toStringAsFixed(2),
            style: TextStyle(
              color: game.type.contains("win") ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryList() {
    final List<Map<String, dynamic>> history = List.generate(
      8,
      (index) => {
        "title": "Ads watch",
        "sats": "+23 Sats",
        "time": "a few seconds ago",
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 66, 66, 66),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children:
            history.map((item) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                title: Text(
                  item["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  item["time"],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                trailing: Text(
                  item["sats"],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  String getTitle(String type){
    if(type.contains("dice")){
      return "Dice";
    }else if(type.contains("wheel")){
      return "Wheel Spin";
    }else{
      return "Ads Watch";
    }
  }

}
