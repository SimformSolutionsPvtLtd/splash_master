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
/// This implementation uses Rive 0.14.x APIs with [RiveWidgetBuilder].
///
/// ```dart
/// SplashMasterRive(
///   source: AssetSource('assets/animation.riv'),
///   riveConfig: const RiveConfig(),
///   nextScreen: const MyApp(),
/// )
/// ```
class SplashMasterRive extends StatefulWidget {
  /// Creates a Rive splash screen that loads from [source].
  ///
  /// [source] must be a [Source] (e.g. [AssetSource], [NetworkFileSource],
  /// [DeviceFileSource], [BytesSource]) or a [RiveFileSource].
  const SplashMasterRive({
    super.key,
    required this.source,
    this.riveConfig = const RiveConfig(),
    this.nextScreen,
    this.customNavigation,
    this.onSourceLoaded,
    this.backGroundColor,
  }) : assert(
          source is Source || source is RiveFileSource,
          'source must be a Source or RiveFileSource',
        );

  /// The source of the Rive animation.
  ///
  /// Accepts a [Source] subtype ([AssetSource], [NetworkFileSource],
  /// [DeviceFileSource], [BytesSource]) or a [RiveFileSource].
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
  State<SplashMasterRive> createState() => _RiveSplashState();
}

class _RiveSplashState extends State<SplashMasterRive> {
  static const _defaultDuration = Duration(seconds: 3);

  Timer? _timer;
  FileLoader? _fileLoader;
  bool _hasNotifiedDuration = false;
  bool _fallbackScheduled = false;

  RiveConfig get _riveConfig => widget.riveConfig;
  VoidCallback get _onSourceLoaded =>
      widget.onSourceLoaded ?? SplashMasterRive.resume;

  @override
  void initState() {
    super.initState();
    _initFileLoader();
  }

  @override
  void didUpdateWidget(covariant SplashMasterRive oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source != oldWidget.source ||
        widget.riveConfig.riveFactory != oldWidget.riveConfig.riveFactory) {
      _fileLoader?.dispose();
      _fileLoader = null;
      _resetDurationState();
      _initFileLoader();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fileLoader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _riveConfig.useSafeArea
        ? SafeArea(child: Center(child: _buildRiveWidget()))
        : Center(child: _buildRiveWidget());

    return Scaffold(
      backgroundColor: widget.backGroundColor,
      body: body,
    );
  }

  void _resetDurationState() {
    _timer?.cancel();
    _hasNotifiedDuration = false;
    _fallbackScheduled = false;
  }

  void _notifyDuration(Duration duration) {
    if (_hasNotifiedDuration) {
      return;
    }
    _hasNotifiedDuration = true;
    _onSourceLoaded.call();
    _timer?.cancel();
    _timer = Timer(duration, _onSplashComplete);
  }

  void _scheduleFallbackDuration() {
    if (_fallbackScheduled) {
      return;
    }
    _fallbackScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _notifyDuration(_riveConfig.splashDuration ?? _defaultDuration);
    });
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

  void _initFileLoader() {
    final source = widget.source;
    final factory = _riveConfig.riveFactory ?? Factory.rive;
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
        _fileLoader = null;
      default:
        _fileLoader = null;
    }
  }

  void _onLoaded(RiveLoaded state) {
    final duration = _riveConfig.splashDuration ?? _defaultDuration;
    _notifyDuration(duration);
    _riveConfig.onInit?.call(state.controller);
  }

  void _onFailed(Object error, StackTrace _) {
    _notifyDuration(_riveConfig.splashDuration ?? _defaultDuration);
  }

  Widget _buildRiveWidget() {
    final loader = _fileLoader;
    if (loader == null) {
      _scheduleFallbackDuration();
      return _riveConfig.placeHolder ??
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
      artboardSelector: _riveConfig.artboardSelector,
      stateMachineSelector: _riveConfig.stateMachineSelector,
      dataBind: _riveConfig.dataBind,
      controller: _riveConfig.controller,
      onLoaded: _onLoaded,
      onFailed: _onFailed,
      builder: (context, state) {
        return switch (state) {
          RiveLoading() =>
            _riveConfig.placeHolder ?? const CircularProgressIndicator(),
          RiveLoaded(:final controller) => RiveWidget(
              controller: controller,
              fit: _riveConfig.fit,
              alignment: _riveConfig.alignment,
              hitTestBehavior: _riveConfig.hitTestBehavior,
              cursor: _riveConfig.cursor,
              layoutScaleFactor: _riveConfig.layoutScaleFactor,
            ),
          RiveFailed(:final error) => Center(
              child: Text('Failed to load Rive: $error'),
            ),
        };
      },
    );
  }
}
