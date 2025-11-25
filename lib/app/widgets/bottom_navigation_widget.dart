import 'package:earnly/app/modules/home/views/home_screen.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:earnly/screens/game_screen.dart';
import 'package:earnly/screens/settings_screen.dart';
import 'package:earnly/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingBottomNavigationWidget extends StatefulWidget {
  final int? index;
  const FloatingBottomNavigationWidget({super.key, this.index});

  @override
  State<FloatingBottomNavigationWidget> createState() =>
      _FloatingBottomNavigationWidgetState();
}

class _FloatingBottomNavigationWidgetState
    extends State<FloatingBottomNavigationWidget> {
  final RxInt currentIndex = 0.obs;

  // final socketController = Get.find<SocketController>();

  @override
  void initState() {
    super.initState();
    currentIndex.value = widget.index ?? 0;
    // if(socketController.socket == null){
    //   socketController.initializeSocket();
    // }
  }

  final List<Widget> items = [
    HomeScreen(),
    GameScreen(),
    WalletScreen(),
    SettingsScreen(),
  ];

  final List<BottomNavItem> navItems = [
    BottomNavItem(icon: Icons.home, label: ''),
    BottomNavItem(icon: Icons.videogame_asset_outlined, label: ''),
    BottomNavItem(icon: Icons.wallet, label: ''),
    BottomNavItem(icon: Icons.settings_outlined, label: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Main content
          Obx(() => items[currentIndex.value]),

          // Floating Bottom Sheet
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildNavigationBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(70),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            navItems.map((item) {
              return Obx(
                () => IconButton(
                  icon: Icon(
                    item.icon,
                    color:
                        currentIndex.value == navItems.indexOf(item)
                            ? AppColors.primaryColor
                            : Colors.grey,
                  ),
                  onPressed: () {
                    currentIndex.value = navItems.indexOf(item);
                  },
                ),
              );
            }).toList(),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({required this.icon, required this.label});
}
