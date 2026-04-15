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
import 'package:lottie/lottie.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_lottie/src/lottie_config.dart';

/// A widget that displays a Lottie animation as a splash screen.
///
/// ```dart
/// LottieSplash(
///   source: AssetSource('assets/animation.json'),
///   nextScreen: const MyApp(),
/// )
/// ```
class LottieSplash extends StatefulWidget {
  const LottieSplash({
    super.key,
    required this.source,
    this.lottieConfig = const LottieConfig(),
    this.nextScreen,
    this.customNavigation,
    this.onSourceLoaded,
    this.backGroundColor,
  });

  final Source source;
  final LottieConfig lottieConfig;

  /// The screen to navigate to after the splash.
  final Widget? nextScreen;

  /// Custom navigation callback. If set, [nextScreen] is ignored.
  final VoidCallback? customNavigation;

  /// Called when the Lottie composition finishes loading.
  final VoidCallback? onSourceLoaded;

  /// Background color of the splash screen.
  final Color? backGroundColor;

  /// Prevents flutter from rendering its first frame until [resume] is called.
  static void initialize() {
    WidgetsBinding.instance.deferFirstFrame();
  }

  /// Resumes Flutter frame rendering.
  static void resume() {
    WidgetsBinding.instance.allowFirstFrame();
  }

  @override
  State<LottieSplash> createState() => _LottieSplashState();
}

class _LottieSplashState extends State<LottieSplash> {
  Timer? _timer;
  late final VoidCallback _onSourceLoaded;

  @override
  void initState() {
    super.initState();
    _onSourceLoaded = widget.onSourceLoaded ?? LottieSplash.resume;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backGroundColor,
      body: Center(child: _lottieMediaWidget(context)),
    );
  }

  Widget _lottieMediaWidget(BuildContext context) {
    switch (widget.lottieConfig.visibilityEnum) {
      case VisibilityEnum.useFullScreen:
        return SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: _lottieWidget,
        );
      case VisibilityEnum.useAspectRatio:
        return AspectRatio(
          aspectRatio: widget.lottieConfig.aspectRatio,
          child: _lottieWidget,
        );
      case VisibilityEnum.none:
        return _lottieWidget;
    }
  }

  Widget get _lottieWidget {
    return LottieBuilder(
      lottie: _getLottieFromSource(),
      controller: widget.lottieConfig.controller,
      frameRate: widget.lottieConfig.frameRate,
      animate: widget.lottieConfig.animate,
      reverse: widget.lottieConfig.reverse,
      repeat: widget.lottieConfig.repeat,
      delegates: widget.lottieConfig.delegates,
      options: widget.lottieConfig.options,
      onLoaded: (composition) {
        _onSourceLoaded.call();
        _timer?.cancel();
        _timer = Timer(composition.duration, _onSplashComplete);
        widget.lottieConfig.onLoaded?.call(composition);
      },
      errorBuilder: widget.lottieConfig.errorBuilder,
      width: widget.lottieConfig.width,
      height: widget.lottieConfig.height,
      fit: widget.lottieConfig.overrideBoxFit
          ? BoxFit.fill
          : widget.lottieConfig.fit,
      alignment: widget.lottieConfig.alignment,
      addRepaintBoundary: widget.lottieConfig.addRepaintBoundary,
      filterQuality: widget.lottieConfig.filterQuality,
      onWarning: widget.lottieConfig.onWarning,
      renderCache: widget.lottieConfig.renderCache,
    );
  }

  LottieProvider _getLottieFromSource() {
    switch (widget.source) {
      case AssetSource assetSource:
        return AssetLottie(assetSource.path);
      case DeviceFileSource deviceFileSource:
        return FileLottie(deviceFileSource.file);
      case NetworkFileSource networkFileSource:
        return NetworkLottie(networkFileSource.path);
      case BytesSource bytesSource:
        return MemoryLottie(bytesSource.bytes);
    }
  }

  void _onSplashComplete() {
    if (!mounted) return;
    if (widget.customNavigation != null) {
      widget.customNavigation!.call();
      return;
    }
    if (widget.nextScreen == null) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.nextScreen!),
    );
  }
}
