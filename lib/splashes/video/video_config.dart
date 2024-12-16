import 'package:video_player/video_player.dart';

enum VisibilityEnum {
  useFullScreen,
  useAspectRatio,
  none,
}

class VideoConfig {
  const VideoConfig({
    this.playImmediately = true,
    this.videoVisibilityEnum = VisibilityEnum.useFullScreen,
    this.useSafeArea = false,
    this.onVideoControllerInitialised,
  });

  final bool playImmediately;

  final bool useSafeArea;
  final VisibilityEnum videoVisibilityEnum;
  final Function(VideoPlayerController)? onVideoControllerInitialised;
}
