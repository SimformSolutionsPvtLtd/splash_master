/// Rive animation splash screen widget for splash_master.
///
/// Add to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   splash_master_rive:
///     path: ../packages/splash_master_rive
/// ```
///
/// Then use [RiveSplash] in your Flutter app:
/// ```dart
/// import 'package:splash_master_rive/splash_master_rive.dart';
///
/// RiveSplash(
///   source: AssetSource('assets/animation.riv'),
///   nextScreen: const MyApp(),
/// )
/// ```
library splash_master_rive;

export 'package:splash_master/splash_master.dart';
export 'src/rive_config.dart';
export 'src/rive_source.dart';
export 'src/rive_splash.dart';
