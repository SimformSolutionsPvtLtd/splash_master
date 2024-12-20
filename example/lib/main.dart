import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_example/assets.dart';
import 'package:splash_master_example/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();
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
      source: AssetSource(Assets.simformSplashVideo),
      videoConfig: const VideoConfig(
        videoVisibilityEnum: VisibilityEnum.useAspectRatio,
      ),
      backGroundColor: Colors.white,
      nextScreen: const Home(),
    );
  }
}
