import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splash_master/configs/video_config.dart';
import 'package:splash_master/configs/lottie_config.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/splash_controller.dart';
import 'package:splash_master/enums/splash_master_enums.dart';
import 'package:splash_master/splashes/lottie_splash.dart';
import 'package:splash_master/splashes/video_splash.dart';

class SplashMaster extends StatefulWidget {
  const SplashMaster.image({
    super.key,
    this.nextScreen,
    this.source,
    this.splashDuration = const Duration(seconds: 1),
    this.customNavigation,
  })  : splashMediaType = SplashMediaType.image,
        lottieConfig = null,
        videoConfig = null,
        assert(source != null, "Source can't be null");

  const SplashMaster.lottie({
    super.key,
    this.nextScreen,
    this.source,
    this.splashDuration = const Duration(seconds: 1),
    this.customNavigation,
    this.lottieConfig,
  })  : splashMediaType = SplashMediaType.lottie,
        videoConfig = null,
        assert(source != null, "Source can't be null");

  const SplashMaster.video({
    super.key,
    required this.nextScreen,
    this.source,
    this.splashDuration = const Duration(seconds: 1),
    this.customNavigation,
    this.videoConfig,
  })  : splashMediaType = SplashMediaType.video,
        lottieConfig = null,
        assert(source != null, "Source can't be null");

  /// The screen which needs to be navigated after the splash screen.
  final Widget? nextScreen;

  /// If an app has custom navigation or page transition then use this callback
  /// to navigate to [nextScreen].
  final VoidCallback? customNavigation;

  /// For this duration splash screen will be shown and then it will be
  /// navigated to [nextScreen].
  final Duration splashDuration;

  /// Type of the media which needs to be used as splash screen.
  final SplashMediaType splashMediaType;

  /// Source for the media which needs to be shown as splash screen.
  final Source? source;

  final LottieConfig? lottieConfig;

  final VideoConfig? videoConfig;

  @override
  State<SplashMaster> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashMaster> {
  late SplashMediaType splashMediaType;
  late final SplashController splashController;

  @override
  void initState() {
    super.initState();
    splashMediaType = widget.splashMediaType;
    splashController = SplashController(
      splashMediaType: splashMediaType,
      source: widget.source!,
    );
    Timer(widget.splashDuration, onSplashComplete);
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

  @override
  Widget build(BuildContext context) {
    return mediaWidget;
  }

  Widget get mediaWidget {
    switch (splashMediaType) {
      case SplashMediaType.image:
        return splashController.getImageFromSource();
      case SplashMediaType.lottie:
        return LottieSplash(
          source: widget.source!,
          lottieConfig: widget.lottieConfig ?? const LottieConfig(),
        );
      case SplashMediaType.video:
        return VideoSplash(
          source: widget.source!,
          videoConfig: widget.videoConfig ?? const VideoConfig(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
