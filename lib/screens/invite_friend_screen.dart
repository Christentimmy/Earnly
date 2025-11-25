import 'package:flutter/material.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF60D07E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Invite Friends",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF60D07E),
      body: const Center(
        child: Text(
          "This is the Invite Friends screen",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
