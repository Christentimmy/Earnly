import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF60D07E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "About App",
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
          "This is the About App screen",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
