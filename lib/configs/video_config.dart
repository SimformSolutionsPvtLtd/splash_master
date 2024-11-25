import 'package:video_player/video_player.dart';

enum VideoVisibilityEnum { useFullScreen, useAspectRatio }

class VideoConfig {
  const VideoConfig({
    this.playImmediately = true,
    this.videoVisibilityEnum = VideoVisibilityEnum.useFullScreen,
    this.useSafeArea = false,
    this.onVideoControllerInitialised,
  });

  final bool playImmediately;

  final bool useSafeArea;
  final VideoVisibilityEnum videoVisibilityEnum;
  final Function(VideoPlayerController)? onVideoControllerInitialised;
}
