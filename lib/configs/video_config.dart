import 'package:video_player/video_player.dart';

class VideoConfig {
  const VideoConfig({
    this.onVideoControllerInit,
    this.playImmediately = true,
    this.useAspectRatio = true,
    this.useSafeArea = false,
    this.useFullScreen = false,
    this.firstFrame,
  });

  final Function(VideoPlayerController)? onVideoControllerInit;
  final bool playImmediately;
  final bool useAspectRatio;
  final bool useSafeArea;
  final bool useFullScreen;
  final String? firstFrame;
}
