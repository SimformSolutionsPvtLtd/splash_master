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

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash_master/splash_master.dart';

class LottieConfig {
  /// A callback called when the LottieComposition has been loaded.
  final void Function(LottieComposition)? onLoaded;

  /// The animation controller of the Lottie animation.
  final Animation<double>? controller;

  /// The number of frames per second to render.
  final FrameRate? frameRate;

  /// Whether or not the Lottie animation should be played automatically.
  final bool? animate;

  /// Whether the automatic animation should repeat in a loop.
  final bool? repeat;

  /// Whether the automatic animation should repeat in reverse mode.
  final bool? reverse;

  /// A group of options to further customize the lottie animation.
  final LottieDelegates? delegates;

  /// Options to enable/disable some features of Lottie.
  final LottieOptions? options;

  /// If non-null, require the lottie animation to have this width.
  final double? width;

  /// If non-null, require the lottie animation to have this height.
  final double? height;

  /// How to inscribe the animation into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the animation within its bounds.
  final AlignmentGeometry? alignment;

  /// Whether to automatically add a RepaintBoundary widget.
  final bool? addRepaintBoundary;

  /// The quality of the image layer.
  final FilterQuality? filterQuality;

  /// A callback called when there is a warning during loading or painting.
  final WarningCallback? onWarning;

  /// A builder function called if an error occurs during loading.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Opt-in to special render mode where frames are lazily cached.
  final RenderCache? renderCache;

  /// Sets BoxFit to fill which removes padding. Defaults to true.
  final bool overrideBoxFit;

  /// Specifies how lottie will be visible (defaults to [VisibilityEnum.useFullScreen])
  final VisibilityEnum visibilityEnum;

  /// Specifies the aspect ratio of the lottie (relevant when using [VisibilityEnum.useAspectRatio])
  final double aspectRatio;

  const LottieConfig({
    this.onLoaded,
    this.controller,
    this.frameRate,
    this.animate,
    this.repeat = false,
    this.reverse,
    this.delegates,
    this.options,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.addRepaintBoundary,
    this.filterQuality,
    this.onWarning,
    this.errorBuilder,
    this.renderCache,
    this.overrideBoxFit = true,
    this.aspectRatio = 9 / 16,
    this.visibilityEnum = VisibilityEnum.useFullScreen,
  });
}
