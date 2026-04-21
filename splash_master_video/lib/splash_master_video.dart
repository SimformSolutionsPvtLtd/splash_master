/// Video splash screen widget for splash_master.
///
/// Add to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   splash_master_video:
///     path: ../packages/splash_master_video  # adjust path as needed
/// ```
///
/// Then use [SplashMasterVideo] in your Flutter app:
/// ```dart
/// import 'package:splash_master_video/splash_master_video.dart';
///
/// SplashMasterVideo(
///   source: AssetSource('assets/splash.mp4'),
///   nextScreen: const MyApp(),
/// )
/// ```
library splash_master_video;

export 'package:splash_master/splash_master.dart';

export 'src/video_config.dart';
export 'src/video_splash.dart';
