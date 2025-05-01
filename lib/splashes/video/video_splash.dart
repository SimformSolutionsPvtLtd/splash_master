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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';
import 'package:splash_master/enums/splash_master_enums.dart';
import 'package:splash_master/splashes/video/video_config.dart';
import 'package:video_player/video_player.dart';

class VideoSplash extends StatefulWidget {
  const VideoSplash({
    super.key,
    required this.source,
    this.videoConfig,
    this.onSplashDuration,
    this.backGroundColor,
  });

  final VideoConfig? videoConfig;
  final Source source;
  final OnSplashDuration? onSplashDuration;
  final Color? backGroundColor;

  @override
  State<VideoSplash> createState() => _VideoSplashState();
}

class _VideoSplashState extends State<VideoSplash> {
  late VideoPlayerController videoController;

  VideoConfig get videoConfig => widget.videoConfig ?? const VideoConfig();

  @override
  void initState() {
    super.initState();
    videoController = _getVideoControllerFromSource();
    videoController.initialize().then(
      (_) {
        if (mounted) setState(() {});
        videoConfig.onVideoControllerInitialised?.call(videoController);
        widget.onSplashDuration?.call(videoController.value.duration);
        if (videoConfig.playImmediately) {
          videoController.play();
        }
      },
    );
  }

  @override
  void dispose() {
    Future.delayed(const Duration(milliseconds: 150)).then((_) {
      videoController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoController.value.isInitialized
        ? ColoredBox(
            color: widget.backGroundColor ?? Colors.transparent,
            child: videoConfig.useSafeArea
                ? SafeArea(child: Center(child: mediaWidget))
                : Center(child: mediaWidget),
          )
        : const SizedBox.shrink();
  }

  Widget get mediaWidget {
    switch (videoConfig.videoVisibilityEnum) {
      case VisibilityEnum.useFullScreen:
        return SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: VideoPlayer(videoController),
        );
      case VisibilityEnum.useAspectRatio:
        return AspectRatio(
          aspectRatio: videoController.value.aspectRatio,
          child: VideoPlayer(videoController),
        );
      case VisibilityEnum.none:
        return VideoPlayer(videoController);
    }
  }

  VideoPlayerController _getVideoControllerFromSource() {
    VideoPlayerController? controller;
    switch (widget.source) {
      case AssetSource assetSource:
        controller = VideoPlayerController.asset(assetSource.path);
        break;
      case DeviceFileSource deviceFileSource:
        controller = VideoPlayerController.file(deviceFileSource.file);
        break;
      case NetworkFileSource networkFileSource:
        final url = networkFileSource.url;
        if (url != null) {
          controller = VideoPlayerController.networkUrl(url);
        } else {
          throw SplashMasterException(
            message: "Url can't be null when playing a remote video",
          );
        }
        break;
      case BytesSource bytesSource:
        final file = File.fromRawPath(bytesSource.bytes);
        controller = VideoPlayerController.file(file);
        break;
      default:
        throw SplashMasterException(message: 'Unknown source found.');
    }
    return controller;
  }
}
