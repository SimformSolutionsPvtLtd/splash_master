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

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';
import 'package:splash_master/splashes/rive/rive_config.dart';

/// A widget that displays a Rive animation as a splash screen
class RiveSplash extends StatefulWidget {
  /// Creates a splash screen with a Rive animation
  const RiveSplash({
    super.key,
    required this.source,
    this.riveConfig = const RiveConfig(),
    this.onSplashDuration,
    this.backGroundColor,
  });

  /// The source of the Rive animation file
  final Source source;

  /// Configuration for the Rive animation
  final RiveConfig riveConfig;

  /// Callback that provides the duration of the splash screen
  final OnSplashDuration? onSplashDuration;

  /// Background color for the splash screen
  final Color? backGroundColor;

  @override
  State<RiveSplash> createState() => _RiveSplashState();
}

class _RiveSplashState extends State<RiveSplash> {
  /// Default duration for Rive animations
  static const defaultDuration = Duration(seconds: 3);

  RiveConfig get riveConfig => widget.riveConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backGroundColor,
      body: Center(
        child: riveWidget,
      ),
    );
  }

  Widget get riveWidget {
    return _getRiveFromSource();
  }

  void _onInit(Artboard artboard) {
    if (artboard.animations.isNotEmpty) {
      final animation = artboard.animations.first;
      Duration duration = Duration.zero;

      if (riveConfig.splashDuration != null) {
        duration = riveConfig.splashDuration!;
      } else if (animation is LinearAnimation) {
        final durationInSeconds = animation.durationSeconds;
        duration = Duration(milliseconds: (durationInSeconds * 1000).round());
      } else {
        duration = defaultDuration;
      }
      widget.onSplashDuration?.call(duration);

      riveConfig.onInit?.call(artboard);
    } else {
      widget.onSplashDuration?.call(riveConfig.splashDuration ?? defaultDuration);
    }
  }

  Widget _getRiveFromSource() {
    switch (widget.source) {
      case AssetSource assetSource:
        return RiveAnimation.asset(
          assetSource.path,
          artboard: riveConfig.artboardName,
          animations: riveConfig.animations,
          stateMachines: riveConfig.stateMachineName,
          fit: riveConfig.fit,
          alignment: riveConfig.alignment,
          controllers: riveConfig.controllers,
          onInit: _onInit,
          antialiasing: riveConfig.antialiasing,
          placeHolder: riveConfig.placeHolder,
          clipRect: riveConfig.clipRect,
          isTouchScrollEnabled: riveConfig.isTouchScrollEnabled,
          speedMultiplier: riveConfig.speedMultiplier,
          behavior: riveConfig.behavior,
          useArtboardSize: riveConfig.useArtboardSize,
          objectGenerator: riveConfig.objectGenerator,
        );
      case DeviceFileSource deviceFileSource:
        return RiveAnimation.file(
          deviceFileSource.path,
          artboard: riveConfig.artboardName,
          animations: riveConfig.animations,
          stateMachines: riveConfig.stateMachineName,
          fit: riveConfig.fit,
          alignment: riveConfig.alignment,
          controllers: riveConfig.controllers,
          onInit: _onInit,
          antialiasing: riveConfig.antialiasing,
          placeHolder: riveConfig.placeHolder,
          clipRect: riveConfig.clipRect,
          isTouchScrollEnabled: riveConfig.isTouchScrollEnabled,
          speedMultiplier: riveConfig.speedMultiplier,
          behavior: riveConfig.behavior,
          useArtboardSize: riveConfig.useArtboardSize,
          objectGenerator: riveConfig.objectGenerator,
        );
      case NetworkFileSource networkFileSource:
        return RiveAnimation.network(
          networkFileSource.url.toString(),
          artboard: riveConfig.artboardName,
          animations: riveConfig.animations,
          stateMachines: riveConfig.stateMachineName,
          fit: riveConfig.fit,
          alignment: riveConfig.alignment,
          controllers: riveConfig.controllers,
          onInit: _onInit,
          antialiasing: riveConfig.antialiasing,
          placeHolder: riveConfig.placeHolder,
          clipRect: riveConfig.clipRect,
          isTouchScrollEnabled: riveConfig.isTouchScrollEnabled,
          speedMultiplier: riveConfig.speedMultiplier,
          behavior: riveConfig.behavior,
          useArtboardSize: riveConfig.useArtboardSize,
          headers: riveConfig.headers,
          objectGenerator: riveConfig.objectGenerator,
        );
      case BytesSource riveBytesSource:
        // Create a RiveFile from bytes
        final riveFile = RiveFile.import(
          riveBytesSource.bytes.buffer.asByteData(),
          assetLoader: riveConfig.assetLoader,
          loadCdnAssets: riveConfig.loadCdnAssets,
          objectGenerator: riveConfig.objectGenerator,
        );
        return RiveAnimation.direct(
          riveFile,
          artboard: riveConfig.artboardName,
          animations: riveConfig.animations,
          stateMachines: riveConfig.stateMachineName,
          fit: riveConfig.fit,
          alignment: riveConfig.alignment,
          controllers: riveConfig.controllers,
          onInit: _onInit,
          antialiasing: riveConfig.antialiasing,
          placeHolder: riveConfig.placeHolder,
          clipRect: riveConfig.clipRect,
          isTouchScrollEnabled: riveConfig.isTouchScrollEnabled,
          speedMultiplier: riveConfig.speedMultiplier,
          behavior: riveConfig.behavior,
          useArtboardSize: riveConfig.useArtboardSize,
        );
      case RiveArtboardSource riveArtboardSource:
        // Use the pre-loaded artboard instance directly
        return Rive(
          artboard: riveArtboardSource.artboard.instance(),
          fit: riveConfig.fit,
          alignment: riveConfig.alignment,
          antialiasing: riveConfig.antialiasing,
          useArtboardSize: riveConfig.useArtboardSize,
          enablePointerEvents: riveConfig.enablePointerEvents,
          cursor: riveConfig.cursor,
          behavior: riveConfig.behavior,
          clipRect: riveConfig.clipRect,
          speedMultiplier: riveConfig.speedMultiplier,
          isTouchScrollEnabled: riveConfig.isTouchScrollEnabled,
        );
    }
  }
}
