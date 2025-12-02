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
///
/// This implementation is designed for Rive 0.14.x which uses the new
/// C++ runtime-based API with [RiveWidgetBuilder] and [RiveWidget].
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

  FileLoader? _fileLoader;

  @override
  void initState() {
    super.initState();
    _initFileLoader();
  }

  @override
  void didUpdateWidget(covariant RiveSplash oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source != oldWidget.source ||
        widget.riveConfig.riveFactory != oldWidget.riveConfig.riveFactory) {
      _fileLoader?.dispose();
      _fileLoader = null;
      _initFileLoader();
    }
  }

  void _initFileLoader() {
    final source = widget.source;
    final factory = riveConfig.riveFactory ?? Factory.rive;
    switch (source) {
      case AssetSource assetSource:
        _fileLoader = FileLoader.fromAsset(
          assetSource.path,
          riveFactory: factory,
        );
      case NetworkFileSource networkSource:
        _fileLoader = FileLoader.fromUrl(
          networkSource.url.toString(),
          riveFactory: factory,
        );
      case RiveFileSource riveFileSource:
        _fileLoader = FileLoader.fromFile(
          riveFileSource.file,
          riveFactory: factory,
        );
      case DeviceFileSource _:
      case BytesSource _:
        // DeviceFileSource and BytesSource are not directly supported by Rive 0.14.x
        // The new Rive API only supports loading from assets, URLs, or pre-loaded File objects.
        // Users should migrate to AssetSource, NetworkFileSource, or RiveFileSource.
        _fileLoader = null;
    }
  }

  @override
  void dispose() {
    _fileLoader?.dispose();
    super.dispose();
  }

  void _onLoaded(RiveLoaded state) {
    // Use provided splashDuration or fall back to defaultDuration.
    final duration = riveConfig.splashDuration ?? defaultDuration;
    widget.onSplashDuration?.call(duration);
    riveConfig.onInit?.call(state.controller);
  }

  void _onFailed(Object error, StackTrace stackTrace) {
    // Report duration on failure to allow splash to complete.
    widget.onSplashDuration?.call(riveConfig.splashDuration ?? defaultDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backGroundColor,
      body: Center(
        child: _buildRiveWidget(),
      ),
    );
  }

  Widget _buildRiveWidget() {
    final loader = _fileLoader;
    if (loader == null) {
      // For unsupported source types, report the duration so the splash flow
      // (onSourceLoaded/resume/navigation) is not left stuck.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSplashDuration
            ?.call(riveConfig.splashDuration ?? defaultDuration);
      });
      // DeviceFileSource and BytesSource are not directly supported in Rive 0.14.x
      // Consider using AssetSource or NetworkFileSource instead
      return riveConfig.placeHolder ??
          const Center(
            child: Text(
              'Unsupported source type for Rive 0.14.x.\n'
              'Use AssetSource, NetworkFileSource, or RiveFileSource instead.',
              textAlign: TextAlign.center,
            ),
          );
    }

    return RiveWidgetBuilder(
      fileLoader: loader,
      artboardSelector: riveConfig.artboardSelector,
      stateMachineSelector: riveConfig.stateMachineSelector,
      dataBind: riveConfig.dataBind,
      controller: riveConfig.controller,
      onLoaded: _onLoaded,
      onFailed: _onFailed,
      builder: (context, state) {
        return switch (state) {
          RiveLoading() =>
            riveConfig.placeHolder ?? const CircularProgressIndicator(),
          RiveLoaded(:final controller) => RiveWidget(
              controller: controller,
              fit: riveConfig.fit,
              alignment: riveConfig.alignment,
              hitTestBehavior: riveConfig.hitTestBehavior,
              cursor: riveConfig.cursor,
              layoutScaleFactor: riveConfig.layoutScaleFactor,
            ),
          RiveFailed(:final error) => Center(
              child: Text('Failed to load Rive: $error'),
            ),
        };
      },
    );
  }
}
