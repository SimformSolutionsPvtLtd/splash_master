/*
 * Copyright (c) 2025 Simform Solutions
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
import 'package:rive/rive.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_rive/src/rive_config.dart';
import 'package:splash_master_rive/src/rive_source.dart';

/// A widget that displays a Rive animation as a splash screen.
///
/// ```dart
/// RiveSplash(
///   source: AssetSource('assets/animation.riv'),
///   riveConfig: const RiveConfig(autoplay: true),
///   nextScreen: const MyApp(),
/// )
/// ```
class RiveSplash extends StatefulWidget {
  /// Creates a Rive splash screen that loads from [source].
  ///
  /// [source] must be a [Source] (e.g. [AssetSource], [NetworkFileSource],
  /// [DeviceFileSource], [BytesSource]) or a [RiveArtboardSource].
  const RiveSplash({
    super.key,
    required this.source,
    this.riveConfig = const RiveConfig(),
    this.nextScreen,
    this.customNavigation,
    this.onSourceLoaded,
    this.backGroundColor,
  }) : assert(
          source is Source || source is RiveArtboardSource,
          'source must be a Source or RiveArtboardSource',
        );

  /// The source of the Rive animation.
  ///
  /// Accepts a [Source] subtype ([AssetSource], [NetworkFileSource],
  /// [DeviceFileSource], [BytesSource]) or a [RiveArtboardSource].
  final RiveSource source;

  /// Configuration for the Rive animation.
  final RiveConfig riveConfig;

  /// The screen to navigate to after the splash.
  final Widget? nextScreen;

  /// Custom navigation callback. If set, [nextScreen] is ignored.
  final VoidCallback? customNavigation;

  /// Called when the source finishes loading (i.e. when frames can be resumed).
  final VoidCallback? onSourceLoaded;

  /// Background color of the splash screen.
  final Color? backGroundColor;

  /// Prevents flutter from rendering its first frame until [resume] is called.
  ///
  /// Call inside `main()` before `runApp` to keep the native splash visible
  /// while loading assets.
  static void initialize() {
    WidgetsBinding.instance.deferFirstFrame();
  }

  /// Resumes Flutter frame rendering.
  static void resume() {
    WidgetsBinding.instance.allowFirstFrame();
  }

  @override
  State<RiveSplash> createState() => _RiveSplashState();
}

class _RiveSplashState extends State<RiveSplash> {
  static const _defaultDuration = Duration(seconds: 3);

  Timer? _timer;
  late final VoidCallback _onSourceLoaded;

  RiveConfig get _riveConfig => widget.riveConfig;

  @override
  void initState() {
    super.initState();
    _onSourceLoaded = widget.onSourceLoaded ?? RiveSplash.resume;
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
      body: Center(child: _riveWidget),
    );
  }

  Widget get _riveWidget => _buildFromSource();

  void _onInit(Artboard artboard) {
    if (artboard.animations.isNotEmpty) {
      final animation = artboard.animations.first;
      Duration duration;

      if (_riveConfig.autoplay &&
          _riveConfig.animations.isEmpty &&
          _riveConfig.stateMachineName.isEmpty) {
        final controller = SimpleAnimation(animation.name);
        artboard.addController(controller);
      }

      if (_riveConfig.splashDuration != null) {
        duration = _riveConfig.splashDuration!;
      } else if (animation is LinearAnimation) {
        final secs = animation.durationSeconds;
        duration = Duration(milliseconds: (secs * 1000).round());
      } else {
        duration = _defaultDuration;
      }
      _notifyDuration(duration);
      _riveConfig.onInit?.call(artboard);
    } else {
      _notifyDuration(_riveConfig.splashDuration ?? _defaultDuration);
    }
  }

  void _notifyDuration(Duration duration) {
    _onSourceLoaded.call();
    _timer?.cancel();
    _timer = Timer(duration, _onSplashComplete);
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

  Widget _buildFromSource() {
    final src = widget.source;

    // Pre-loaded artboard case
    if (src is RiveArtboardSource) {
      return Rive(
        artboard: src.artboard.instance(),
        fit: _riveConfig.fit,
        alignment: _riveConfig.alignment,
        antialiasing: _riveConfig.antialiasing,
        useArtboardSize: _riveConfig.useArtboardSize,
        enablePointerEvents: _riveConfig.enablePointerEvents,
        cursor: _riveConfig.cursor,
        behavior: _riveConfig.behavior,
        clipRect: _riveConfig.clipRect,
        speedMultiplier: _riveConfig.speedMultiplier,
        isTouchScrollEnabled: _riveConfig.isTouchScrollEnabled,
      );
    }

    // Standard Source cases
    final List<String> animations =
        _riveConfig.autoplay ? _riveConfig.animations : [];
    final List<String> stateMachines =
        _riveConfig.autoplay ? _riveConfig.stateMachineName : [];

    switch (src as Source) {
      case AssetSource assetSource:
        return RiveAnimation.asset(
          assetSource.path,
          artboard: _riveConfig.artboardName,
          animations: animations,
          stateMachines: stateMachines,
          fit: _riveConfig.fit,
          alignment: _riveConfig.alignment,
          controllers: _riveConfig.controllers,
          onInit: _onInit,
          antialiasing: _riveConfig.antialiasing,
          placeHolder: _riveConfig.placeHolder,
          clipRect: _riveConfig.clipRect,
          isTouchScrollEnabled: _riveConfig.isTouchScrollEnabled,
          speedMultiplier: _riveConfig.speedMultiplier,
          behavior: _riveConfig.behavior,
          useArtboardSize: _riveConfig.useArtboardSize,
          objectGenerator: _riveConfig.objectGenerator,
        );
      case DeviceFileSource deviceFileSource:
        return RiveAnimation.file(
          deviceFileSource.path,
          artboard: _riveConfig.artboardName,
          animations: animations,
          stateMachines: stateMachines,
          fit: _riveConfig.fit,
          alignment: _riveConfig.alignment,
          controllers: _riveConfig.controllers,
          onInit: _onInit,
          antialiasing: _riveConfig.antialiasing,
          placeHolder: _riveConfig.placeHolder,
          clipRect: _riveConfig.clipRect,
          isTouchScrollEnabled: _riveConfig.isTouchScrollEnabled,
          speedMultiplier: _riveConfig.speedMultiplier,
          behavior: _riveConfig.behavior,
          useArtboardSize: _riveConfig.useArtboardSize,
          objectGenerator: _riveConfig.objectGenerator,
        );
      case NetworkFileSource networkFileSource:
        return RiveAnimation.network(
          networkFileSource.url.toString(),
          artboard: _riveConfig.artboardName,
          animations: animations,
          stateMachines: stateMachines,
          fit: _riveConfig.fit,
          alignment: _riveConfig.alignment,
          controllers: _riveConfig.controllers,
          onInit: _onInit,
          antialiasing: _riveConfig.antialiasing,
          placeHolder: _riveConfig.placeHolder,
          clipRect: _riveConfig.clipRect,
          isTouchScrollEnabled: _riveConfig.isTouchScrollEnabled,
          speedMultiplier: _riveConfig.speedMultiplier,
          behavior: _riveConfig.behavior,
          useArtboardSize: _riveConfig.useArtboardSize,
          headers: _riveConfig.headers,
          objectGenerator: _riveConfig.objectGenerator,
        );
      case BytesSource bytesSource:
        final riveFile = RiveFile.import(
          bytesSource.bytes.buffer.asByteData(),
          assetLoader: _riveConfig.assetLoader,
          loadCdnAssets: _riveConfig.loadCdnAssets,
          objectGenerator: _riveConfig.objectGenerator,
        );
        return RiveAnimation.direct(
          riveFile,
          artboard: _riveConfig.artboardName,
          animations: animations,
          stateMachines: stateMachines,
          fit: _riveConfig.fit,
          alignment: _riveConfig.alignment,
          controllers: _riveConfig.controllers,
          onInit: _onInit,
          antialiasing: _riveConfig.antialiasing,
          placeHolder: _riveConfig.placeHolder,
          clipRect: _riveConfig.clipRect,
          isTouchScrollEnabled: _riveConfig.isTouchScrollEnabled,
          speedMultiplier: _riveConfig.speedMultiplier,
          behavior: _riveConfig.behavior,
          useArtboardSize: _riveConfig.useArtboardSize,
        );
    }
  }
}
