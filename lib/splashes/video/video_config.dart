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

import 'package:video_player/video_player.dart';

enum VisibilityEnum {
  /// To display video in full screen
  useFullScreen,

  /// To display video as per its aspect ratio
  useAspectRatio,

  /// None
  none,
}

class VideoConfig {
  /// Provides the configurations for the video
  const VideoConfig({
    this.playImmediately = true,
    this.videoVisibilityEnum = VisibilityEnum.useFullScreen,
    this.useSafeArea = false,
    this.onVideoControllerInitialised,
  });

  /// Once video resource initialized play immediately (defaults to true)
  ///
  /// If it is false, then you need to call `play()` method explicitly through [onVideoControllerInitialised] function.
  /// ```dart
  ///   onVideoControllerInitialised: (videoController) {
  ///        videoController.play();
  ///   }
  /// ```
  final bool playImmediately;

  /// Specifies to use safe area while displaying video on screen
  final bool useSafeArea;

  /// Specifies how video will be visible (defaults to [VisibilityEnum.useFullScreen])
  ///
  /// Other value is [VisibilityEnum.useAspectRatio] to use aspect ratio of video
  final VisibilityEnum videoVisibilityEnum;

  /// Provides the callback with [VideoPlayerController] as argument on video controller initialized
  final Function(VideoPlayerController videoController)?
      onVideoControllerInitialised;
}
