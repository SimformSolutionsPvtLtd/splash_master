import 'package:flutter/material.dart';
import 'package:splash_master_lottie/splash_master_lottie.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterLottie.initialize();
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
    return SplashMasterLottie(
      source: AssetSource('assets/simform_splash_lottie.json'),
      lottieConfig: const LottieConfig(
        repeat: false,
        visibilityEnum: VisibilityEnum.useAspectRatio,
        aspectRatio: 16 / 9,
      ),
      onSourceLoaded: () {
        // Resume Flutter frame rendering once the video source is loaded and ready to play.
        SplashMasterLottie.resume();

        // IMPORTANT- Remove the native splash screen (if added) after
        // a short delay to ensure the video starts playing smoothly.
        SplashMasterDesktop.removeSplash(
          delay: const Duration(milliseconds: 50),
        );
      },
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
