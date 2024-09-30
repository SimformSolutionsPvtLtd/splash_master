import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_example/assets.dart';

void main() {
  runApp(const SplashScreen());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMaster(
      nextScreen: Container(),
      source: AssetSource(Assets.flutterDash),
    );
  }
}
