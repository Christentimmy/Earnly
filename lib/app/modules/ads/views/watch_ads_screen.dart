import 'dart:async';
import 'package:earnly/app/controllers/earn_controller.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class WatchAdsScreen extends StatefulWidget {
  final String url;
  const WatchAdsScreen({super.key, required this.url});

  @override
  State<WatchAdsScreen> createState() => _WatchAdsScreenState();
}

class _WatchAdsScreenState extends State<WatchAdsScreen> {
  late VideoPlayerController _controller;
  RxInt countDownTimer = 30.obs;
  final earnController = Get.find<EarnController>();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) async {
        setState(() {});
        _controller.play();
        Timer.periodic(Duration(seconds: 1), (_) {
          countDownTimer.value--;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child:
                  _controller.value.isInitialized
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : const CircularProgressIndicator(color: Colors.white),
            ),

            Positioned(
              top: 20,
              right: 20,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() {
                  if (countDownTimer.value > 1) {
                    return Text(
                      "${countDownTimer.value}s",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () async {
                      Get.back();
                      await earnController.completedAd();
                    },
                    child: Icon(Icons.close, color: Colors.white),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
