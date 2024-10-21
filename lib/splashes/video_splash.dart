import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splash_master/configs/image_config.dart';
import 'package:splash_master/configs/video_config.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';
import 'package:video_player/video_player.dart';

class VideoSplash extends StatefulWidget {
  const VideoSplash({
    super.key,
    required this.source,
    required this.firstFrameConfig,
    this.videoConfig,
    this.onSplashDuration,
  });

  final VideoConfig? videoConfig;
  final Source source;
  final ImageConfig firstFrameConfig;
  final OnSplashDuration? onSplashDuration;

  @override
  State<VideoSplash> createState() => _VideoSplashState();
}

class _VideoSplashState extends State<VideoSplash> {
  late final VideoPlayerController videoController;

  VideoConfig get videoConfig => widget.videoConfig ?? const VideoConfig();

  ImageConfig get firstFrameConfig => widget.firstFrameConfig;

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
                child: firstFrame,
              )
            } else if (videoConfig.useAspectRatio) ...{
              AspectRatio(
                aspectRatio: videoConfig.firstFrameAspectRatio,
                child: firstFrame,
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

  Widget get firstFrame {
    if (videoConfig.firstFrame == null) return const SizedBox.shrink();
    return Image.asset(
      videoConfig.firstFrame!,
      fit: firstFrameConfig.fit,
      frameBuilder: firstFrameConfig.frameBuilder,
      alignment: firstFrameConfig.alignment,
      height: firstFrameConfig.height,
      width: firstFrameConfig.width,
      scale: firstFrameConfig.scale,
      opacity: firstFrameConfig.opacity,
      color: firstFrameConfig.color,
      errorBuilder: firstFrameConfig.errorBuilder,
      filterQuality: firstFrameConfig.filterQuality,
      gaplessPlayback: firstFrameConfig.gaplessPlayback,
      isAntiAlias: firstFrameConfig.isAntiAlias,
      centerSlice: firstFrameConfig.centerSlice,
      colorBlendMode: firstFrameConfig.colorBlendMode,
      semanticLabel: firstFrameConfig.semanticLabel,
      repeat: firstFrameConfig.repeat,
      matchTextDirection: firstFrameConfig.matchTextDirection,
      excludeFromSemantics: firstFrameConfig.excludeFromSemantics,
      cacheWidth: firstFrameConfig.cacheWidth,
      cacheHeight: firstFrameConfig.cacheHeight,
      package: firstFrameConfig.package,
      bundle: firstFrameConfig.bundle,
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
