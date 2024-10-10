import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoConfig {
  const VideoConfig({
    this.onVideoControllerInit,
    this.playImmediately = true,
    this.useAspectRatio = true,
    this.useSafeArea = false,
    this.useFullScreen = false,
    this.firstFrame,
    this.firstFrameAspectRatio = 9 / 16,
    this.backgroundColor,
  }) : assert(
          !(useFullScreen && useAspectRatio),
          "useFullScreen and useAspectRatio can't be true at same time.",
        );

  final Function(VideoPlayerController)? onVideoControllerInit;
  final bool playImmediately;
  final bool useAspectRatio;
  final bool useSafeArea;
  final bool useFullScreen;
  final String? firstFrame;
  final double firstFrameAspectRatio;
  final Color? backgroundColor;
}
