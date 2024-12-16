/*
 * Copyright (c) 2024 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master/splashes/lottie/lottie_splash.dart';
import 'package:splash_master/splashes/video/video_splash.dart';

class SplashMaster extends StatefulWidget {
  /// Set lottie as splash screen
  const SplashMaster.lottie({
    super.key,
    this.nextScreen,
    required this.source,
    this.customNavigation,
    this.lottieConfig,
    this.onSourceLoaded,
    this.backGroundColor,
  })  : splashMediaType = SplashMediaType.lottie,
        videoConfig = null;

  /// Set video as splash screen
  const SplashMaster.video({
    super.key,
    this.nextScreen,
    required this.source,
    this.customNavigation,
    this.videoConfig,
    this.onSourceLoaded,
    this.backGroundColor,
  })  : splashMediaType = SplashMediaType.video,
        lottieConfig = null;

  /// The screen which needs to be navigated after the splash screen.
  final Widget? nextScreen;

  /// If an app has custom navigation or page transition then use this callback
  /// to navigate to [nextScreen].
  final VoidCallback? customNavigation;

  /// A config class for lottie splash. Have default parameters which lottie
  /// provides.
  final LottieConfig? lottieConfig;

  /// A config class for video splash. Controls how a video player preview will
  /// look.
  final VideoConfig? videoConfig;

  /// [backGroundColor] of the screen when video or lottie is being displayed using aspect ratio
  final Color? backGroundColor;

  /// A callback when provided source completes initializing.
  final VoidCallback? onSourceLoaded;

  /// Type of the media which needs to be used as splash screen.
  final SplashMediaType splashMediaType;

  /// Source for the media which needs to be shown as splash screen.
  final Source source;

  /// Prevents flutter frame to be rendered but framework will still produce
  /// frames.
  ///
  /// Call this in `main` method before any other methods to load provided
  /// source and other dependencies.
  ///
  /// To resume flutter frames call [resume]. Before `resume` is called, app
  /// wait in native splash screen.
  ///
  /// ```dart
  /// void main() {
  ///  WidgetsFlutterBinding.ensureInitialized();
  ///  SplashMaster.initialize();
  ///  runApp(
  ///    MaterialApp(
  ///      home: SplashMaster.video(...),
  ///    ),
  ///  );
  /// }
  ///
  /// ```
  static void initialize() {
    WidgetsBinding.instance.deferFirstFrame();
  }

  /// Resumes flutter to start rendering frames.
  static void resume() {
    WidgetsBinding.instance.allowFirstFrame();
  }

  @override
  State<SplashMaster> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashMaster> {
  Timer? timer;

  late final VoidCallback onSourceLoaded;

  Source get source => widget.source;

  @override
  void initState() {
    super.initState();
    onSourceLoaded = widget.onSourceLoaded ?? SplashMaster.resume;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mediaWidget;
  }

  Widget get mediaWidget {
    switch (widget.splashMediaType) {
      case SplashMediaType.lottie:
        return LottieSplash(
          source: source,
          lottieConfig: widget.lottieConfig ?? const LottieConfig(),
          backGroundColor: widget.backGroundColor,
          onSplashDuration: _updateSplashDuration,
        );
      case SplashMediaType.video:
        return VideoSplash(
          source: source,
          videoConfig: widget.videoConfig,
          backGroundColor: widget.backGroundColor,
          onSplashDuration: _updateSplashDuration,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _updateSplashDuration(Duration duration) {
    onSourceLoaded.call();

    timer?.cancel();
    timer = Timer(duration, onSplashComplete);
  }

  void onSplashComplete() {
    if (widget.customNavigation != null) {
      widget.customNavigation!.call();
    } else {
      if (widget.nextScreen == null) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) {
            return widget.nextScreen!;
          },
        ),
      );
    }
  }
}
