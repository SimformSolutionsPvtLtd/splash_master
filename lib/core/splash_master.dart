import 'package:flutter/material.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/splash_controller.dart';
import 'package:splash_master/core/utils.dart';

class SplashMaster extends StatefulWidget {
  const SplashMaster({
    super.key,
    required this.nextScreen,
    this.source,
    this.splashDuration = const Duration(seconds: 1),
    this.customNavigation,
    this.splashMediaType = SplashMediaType.image,
  }) : assert(source != null, "Source can't be null");

  /// The screen which needs to be navigated after the splash screen.
  final Widget nextScreen;

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
  }

  @override
  Widget build(BuildContext context) {
    return mediaWidget;
  }

  Widget get mediaWidget {
    switch (splashMediaType) {
      case SplashMediaType.image:
        return splashController.getImageFromSource();
      default:
        return const SizedBox.shrink();
    }
  }
}
