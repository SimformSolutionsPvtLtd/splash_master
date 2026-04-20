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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_video/src/video_config.dart';
import 'package:video_player/video_player.dart';

/// A widget that displays a video as a splash screen.
///
/// ```dart
/// SplashMasterVideo(
///   source: AssetSource('assets/splash.mp4'),
///   videoConfig: const VideoConfig(
///     videoVisibilityEnum: VisibilityEnum.useAspectRatio,
///   ),
///   nextScreen: const MyApp(),
/// )
/// ```
class SplashMasterVideo extends StatefulWidget {
  const SplashMasterVideo({
    super.key,
    required this.source,
    this.videoConfig,
    this.nextScreen,
    this.customNavigation,
    this.onSourceLoaded,
    this.backGroundColor,
  });

  final Source source;
  final VideoConfig? videoConfig;

  /// The screen to navigate to after the splash.
  final Widget? nextScreen;

  /// Custom navigation callback. If set, [nextScreen] is ignored.
  final VoidCallback? customNavigation;

  /// Called when the video finishes loading (i.e. when frames can be resumed).
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
  State<SplashMasterVideo> createState() => _VideoSplashState();
}

class _VideoSplashState extends State<SplashMasterVideo> {
  late VideoPlayerController _videoController;
  Timer? _timer;
  late final VoidCallback _onSourceLoaded;

  VideoConfig get _videoConfig => widget.videoConfig ?? const VideoConfig();

  @override
  void initState() {
    super.initState();
    _onSourceLoaded = widget.onSourceLoaded ?? SplashMasterVideo.resume;
    _videoController = _getVideoControllerFromSource();
    _videoController.initialize().then((_) {
      if (mounted) setState(() {});
      _videoConfig.onVideoControllerInitialised?.call(_videoController);
      _onSourceLoaded.call();
      _timer = Timer(_videoController.value.duration, _onSplashComplete);
      if (_videoConfig.playImmediately) {
        _videoController.play();
      }
    }).catchError((Object error, StackTrace stackTrace) {
      _onSourceLoaded.call();
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'splash_master_video',
          context: ErrorDescription('while initializing video splash'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    Future.delayed(const Duration(milliseconds: 150)).then((_) {
      _videoController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? ColoredBox(
            color: widget.backGroundColor ?? Colors.transparent,
            child: _videoConfig.useSafeArea
                ? SafeArea(child: Center(child: _mediaWidget))
                : Center(child: _mediaWidget),
          )
        : ColoredBox(
            color: widget.backGroundColor ?? Colors.transparent,
            child: const SizedBox.expand(),
          );
  }

  Widget get _mediaWidget {
    switch (_videoConfig.videoVisibilityEnum) {
      case VisibilityEnum.useFullScreen:
        return SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: VideoPlayer(_videoController),
        );
      case VisibilityEnum.useAspectRatio:
        return AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        );
      case VisibilityEnum.none:
        return VideoPlayer(_videoController);
    }
  }

  VideoPlayerController _getVideoControllerFromSource() {
    switch (widget.source) {
      case AssetSource assetSource:
        return VideoPlayerController.asset(assetSource.path);
      case DeviceFileSource deviceFileSource:
        return VideoPlayerController.file(deviceFileSource.file);
      case NetworkFileSource networkFileSource:
        final url = networkFileSource.url;
        if (url != null) {
          return VideoPlayerController.networkUrl(url);
        }
        throw SplashMasterException(
          message: "Url can't be null when playing a remote video",
        );
      case BytesSource bytesSource:
        return VideoPlayerController.file(File.fromRawPath(bytesSource.bytes));
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
