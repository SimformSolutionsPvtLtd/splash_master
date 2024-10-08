import 'package:flutter/material.dart';
import 'package:splash_master/configs/video_config.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_example/assets.dart';
import 'package:splash_master_example/home.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMaster.video(
      nextScreen: const Home(
        title: 'Home',
      ),
      source: AssetSource(Assets.sampleVideo),
      videoConfig: const VideoConfig(
        firstFrame: 'assets/splash_image.jpg',
        useFullScreen: true,
        useAspectRatio: false,
      ),
    );
  }
}
