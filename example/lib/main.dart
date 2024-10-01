import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_example/assets.dart';
import 'package:splash_master_example/home.dart';

void main() {
  runApp(
    const MaterialApp(
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
      splashDuration: const Duration(seconds: 2),
      source: AssetSource(Assets.sampleLottie),
    );
  }
}
