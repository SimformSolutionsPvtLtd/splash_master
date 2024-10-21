import 'package:flutter/material.dart';
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
    return SplashMaster.image(
      nextScreen: const Home(
        title: 'Home',
      ),
      splashDuration: const Duration(seconds: 1),
      source: AssetSource(Assets.sampleSplashScreen),
      imageConfig: const ImageConfig(fit: BoxFit.fill),
    );
  }
}
