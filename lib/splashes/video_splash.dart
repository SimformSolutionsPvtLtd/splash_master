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
    this.videoConfig = const VideoConfig(),
    this.onVideoInitialise,
  });

  final VideoConfig videoConfig;
  final Source source;
  final OnVideoDuration? onVideoInitialise;

  @override
  State<VideoSplash> createState() => _VideoSplashState();
}

class _VideoSplashState extends State<VideoSplash> {
  late final VideoPlayerController videoController;

  VideoConfig get videoConfig => widget.videoConfig;

  @override
  void initState() {
    super.initState();
    videoController = getVideoControllerFromSource();
    videoController.initialize().then(
      (_) {
        widget.onVideoInitialise?.call(videoController.value.duration);
        videoConfig.onVideoControllerInit?.call(videoController);
        if (mounted) setState(() {});
        if (videoConfig.playImmediately) {
          videoController.play();
        }
      },
    );
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: videoConfig.useSafeArea
          ? SafeArea(child: splashWidget)
          : splashWidget,
    );
  }

  Widget get splashWidget {
    return Center(
      child: videoConfig.useAspectRatio
          ? AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: mediaWidget,
            )
          : SizedBox.fromSize(
              size:
                  videoConfig.useFullScreen ? MediaQuery.sizeOf(context) : null,
              child: mediaWidget,
            ),
    );
  }

  Widget get mediaWidget {
    return videoController.value.isInitialized
        ? VideoPlayer(videoController)
        : videoConfig.firstFrame != null
            ? Image.asset(
                videoConfig.firstFrame!,
                fit: BoxFit.fill,
              )
            : const SizedBox.shrink();
  }

  VideoPlayerController getVideoControllerFromSource() {
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
