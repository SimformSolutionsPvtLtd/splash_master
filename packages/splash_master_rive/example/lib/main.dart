import 'package:flutter/material.dart';
import 'package:splash_master_rive/splash_master_rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RiveSplash.initialize();
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
    return RiveSplash(
      source: AssetSource('assets/sample_rive.riv'),
      riveConfig: const RiveConfig(),
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
