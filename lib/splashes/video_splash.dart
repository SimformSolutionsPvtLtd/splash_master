import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splash_master/configs/video_config.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';
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
    if (videoConfig.videoVisibilityEnum == VideoVisibilityEnum.useFullScreen) {
      return SizedBox.fromSize(
        size: MediaQuery.sizeOf(context),
        child: VideoPlayer(videoController),
      );
    } else if (videoConfig.videoVisibilityEnum ==
        VideoVisibilityEnum.useAspectRatio) {
      return AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: VideoPlayer(videoController),
      );
    } else {
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
    }
    if (controller == null) {
      throw SplashMasterException(
        message: "Unknown source, video controller is null",
      );
    }
    return controller;
  }
}
