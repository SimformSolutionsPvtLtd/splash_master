/// Lottie animation splash screen widget for splash_master.
///
/// Add to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   splash_master_lottie:
///     path: ../packages/splash_master_lottie  # adjust path as needed
/// ```
///
/// Then use [LottieSplash] in your Flutter app:
/// ```dart
/// import 'package:splash_master_lottie/splash_master_lottie.dart';
///
/// LottieSplash(
///   source: AssetSource('assets/animation.json'),
///   nextScreen: const MyApp(),
/// )
/// ```
library splash_master_lottie;

export 'package:splash_master/splash_master.dart';
export 'src/lottie_config.dart';
export 'src/lottie_splash.dart';
