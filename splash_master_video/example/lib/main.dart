import 'package:flutter/material.dart';
import 'package:splash_master_video/splash_master_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterVideo.initialize();
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
    return SplashMasterVideo(
      source: AssetSource('assets/simform_splash_video.mp4'),
      onSourceLoaded: () async {
        // Resume Flutter frame rendering once the video source is loaded and ready to play.
        SplashMasterVideo.resume();

        // IMPORTANT- Remove the native splash screen (if added) after
        // a short delay to ensure the video starts playing smoothly.
        SplashMasterDesktop.removeSplash(
          delay: const Duration(milliseconds: 50),
        );
      },
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
