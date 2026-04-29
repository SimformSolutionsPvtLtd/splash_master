import 'package:flutter/material.dart';
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterRive.initialize();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RiveSplashScreen(),
    ),
  );
}

class RiveSplashScreen extends StatelessWidget {
  const RiveSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashMasterRive(
      source: AssetSource('assets/simform_logo_animation.riv'),
      riveConfig: const RiveConfig(),
      onSourceLoaded: () {
        // Resume Flutter frame rendering once the video source is loaded and ready to play.
        SplashMasterRive.resume();

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
      appBar: AppBar(title: const Text('Rive Splash Example')),
      body: const Center(
        child: Text('Rive splash complete!'),
      ),
    );
  }
}
