import 'package:flutter/material.dart';
import 'package:splash_master/configs/lottie_config.dart';
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
    return SplashMaster.lottie(
      nextScreen: const Home(
        title: 'Home',
      ),
      lottieConfig: const LottieConfig(
        backgroundColor: Color(0xFF040406),
      ),
      source: AssetSource(Assets.sampleLottie),
    );
  }
}
