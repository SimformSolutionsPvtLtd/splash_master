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
  });

  final VideoConfig? videoConfig;
  final Source source;
  final OnSplashDuration? onSplashDuration;

  @override
  State<VideoSplash> createState() => _VideoSplashState();
}

class _VideoSplashState extends State<VideoSplash> {
  late final VideoPlayerController videoController;

  VideoConfig get videoConfig => widget.videoConfig ?? const VideoConfig();

  @override
  void initState() {
    super.initState();
    videoController = getVideoControllerFromSource();
    videoController.initialize().then(
      (_) {
        widget.onSplashDuration?.call(videoController.value.duration);
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
      backgroundColor: videoConfig.backgroundColor,
      body:
          videoConfig.useSafeArea ? SafeArea(child: mediaWidget) : mediaWidget,
    );
  }

  Widget get mediaWidget {
    return Center(
      child: Stack(
        children: [
          if (videoConfig.firstFrame != null) ...{
            if (videoConfig.useFullScreen) ...{
              SizedBox.fromSize(
                size: MediaQuery.sizeOf(context),
                child: Image.asset(videoConfig.firstFrame!),
              )
            } else if (videoConfig.useAspectRatio) ...{
              AspectRatio(
                aspectRatio: videoConfig.firstFrameAspectRatio,
                child: Image.asset(videoConfig.firstFrame!),
              ),
            },
          } else ...{
            Image.asset(videoConfig.firstFrame!),
          },
          if (videoController.value.isInitialized) ...{
            if (videoConfig.useFullScreen) ...{
              SizedBox.fromSize(
                size: MediaQuery.sizeOf(context),
                child: VideoPlayer(videoController),
              ),
            } else if (videoConfig.useAspectRatio) ...{
              AspectRatio(
                aspectRatio: videoController.value.aspectRatio,
                child: VideoPlayer(videoController),
              )
            } else ...{
              VideoPlayer(videoController),
            },
          }
        ],
      ),
    );
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
