import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LottieSplash.initialize();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LottieSplashScreen(),
    ),
  );
}

class LottieSplashScreen extends StatelessWidget {
  const LottieSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LottieSplash(
      source: AssetSource('assets/sample_lottie.json'),
      lottieConfig: const LottieConfig(
        repeat: false,
        visibilityEnum: VisibilityEnum.useAspectRatio,
        aspectRatio: 1.0,
      ),
      backGroundColor: Colors.white,
      nextScreen: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lottie Splash Example')),
      body: const Center(
        child: Text('Lottie splash complete!'),
      ),
    );
  }
}
