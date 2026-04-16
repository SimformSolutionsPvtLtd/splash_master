import 'package:flutter/material.dart';
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  VideoSplash.initialize();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoSplashScreen(),
    ),
  );
}

class VideoSplashScreen extends StatelessWidget {
  const VideoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoSplash(
      source: AssetSource('assets/simform_splash_video.mp4'),
      videoConfig: const VideoConfig(
        videoVisibilityEnum: VisibilityEnum.useAspectRatio,
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
      appBar: AppBar(title: const Text('Video Splash Example')),
      body: const Center(
        child: Text('Video splash complete!'),
      ),
    );
  }
}
