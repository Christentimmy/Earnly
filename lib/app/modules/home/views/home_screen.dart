import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF60D07E),
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
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.7),
                              foregroundColor: Colors.black54,
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
                              "Earn Points",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                            color: Colors.black87,
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
                    _buildHistoryList(),
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
                color: const Color(0xFF60D07E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Row
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/profile.png'),
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
                            children: const [
                              Text(
                                "Total Earnings",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "234,000 sats",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
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

  // 🔹 History List Widget
  static Widget _buildHistoryList() {
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
}
