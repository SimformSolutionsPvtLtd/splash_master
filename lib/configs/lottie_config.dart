import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash_master/core/utils.dart';

class LottieConfig {
  /// A callback called when the LottieComposition has been loaded.
  /// You can use this callback to set the correct duration on the AnimationController
  /// with `composition.duration`
  final void Function(LottieComposition)? onLoaded;

  /// The animation controller of the Lottie animation.
  /// The animated value will be mapped to the `progress` property of the
  /// Lottie animation.
  final Animation<double>? controller;

  /// The number of frames per second to render.
  /// Use `FrameRate.composition` to use the original frame rate of the Lottie composition (default)
  /// Use `FrameRate.max` to advance the animation progression at every frame.
  final FrameRate? frameRate;

  /// If no controller is specified, this value indicate whether or not the
  /// Lottie animation should be played automatically (default to true).
  /// If there is an animation controller specified, this property has no effect.
  ///
  /// See [repeat] to control whether the animation should repeat.
  final bool? animate;

  /// Specify that the automatic animation should repeat in a loop (default to true).
  /// The property has no effect if [animate] is false or [controller] is not null.
  final bool? repeat;

  /// Specify that the automatic animation should repeat in a loop in a "reverse"
  /// mode (go from start to end and then continuously from end to start).
  /// It default to false.
  /// The property has no effect if [animate] is false, [repeat] is false or [controller] is not null.
  final bool? reverse;

  /// A group of options to further customize the lottie animation.
  /// - A [text] delegate to dynamically change some text displayed in the animation
  /// - A value callback to change the properties of the animation at runtime.
  /// - A text style factory to map between a font family specified in the animation
  ///   and the font family in your assets.
  final LottieDelegates? delegates;

  /// Some options to enable/disable some feature of Lottie
  /// - enableMergePaths: Enable merge path support
  /// - enableApplyingOpacityToLayers: Enable layer-level opacity
  final LottieOptions? options;

  /// If non-null, require the lottie animation to have this width.
  ///
  /// If null, the lottie animation will pick a size that best preserves its intrinsic
  /// aspect ratio.
  ///
  /// It is strongly recommended that either both the [width] and the [height]
  /// be specified, or that the widget be placed in a context that sets tight
  /// layout constraints, so that the animation does not change size as it loads.
  /// Consider using [fit] to adapt the animation's rendering to fit the given width
  /// and height if the exact animation dimensions are not known in advance.
  final double? width;

  /// If non-null, require the lottie animation to have this height.
  ///
  /// If null, the lottie animation will pick a size that best preserves its intrinsic
  /// aspect ratio.
  ///
  /// It is strongly recommended that either both the [width] and the [height]
  /// be specified, or that the widget be placed in a context that sets tight
  /// layout constraints, so that the animation does not change size as it loads.
  /// Consider using [fit] to adapt the animation's rendering to fit the given width
  /// and height if the exact animation dimensions are not known in advance.
  final double? height;

  /// How to inscribe the animation into the space allocated during layout.
  ///
  /// The default varies based on the other fields. See the discussion at
  /// [paintImage].
  final BoxFit? fit;

  /// How to align the animation within its bounds.
  final AlignmentGeometry? alignment;

  /// Indicate to automatically add a `RepaintBoundary` widget around the animation.
  /// This allows to optimize the app performance by isolating the animation in its
  /// own `Layer`.
  ///
  /// This property is `true` by default.
  final bool? addRepaintBoundary;

  /// The quality of the image layer. See [FilterQuality]
  /// [FilterQuality.high] is highest quality but slowest.
  ///
  /// Defaults to [FilterQuality.low]
  final FilterQuality? filterQuality;

  /// A callback called when there is a warning during the loading or painting
  /// of the animation.
  final WarningCallback? onWarning;

  /// A builder function that is called if an error occurs during loading.
  ///
  /// If this builder is not provided, any exceptions will be reported to
  /// [FlutterError.onError]. If it is provided, the caller should either handle
  /// the exception by providing a replacement widget, or rethrow the exception.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Opt-in to a special render mode where the frames of the animation are
  /// lazily rendered and kept in a cache.
  /// Subsequent runs of the animation will be cheaper to render.
  ///
  /// This is useful is the animation is complex and can consume lot of energy
  /// from the battery.
  /// This will trade an excessive CPU usage for an increase memory usage.
  /// The main use-case is a short and small (size on the screen) animation that is
  /// played repeatedly.
  ///
  /// There are 2 kinds of caches:
  /// - [RenderCache.raster]: keep the frame rasterized in the cache (as [dart:ui.Image]).
  ///   Subsequent runs of the animation are very cheap for both the CPU and GPU but it takes
  ///   a lot of memory (rendered_width * rendered_height * frame_rate * duration_of_the_animation).
  ///   This should only be used for very short and very small animations.
  /// - [RenderCache.drawingCommands]: keep the frame as a list of graphical operations ([dart:ui.Picture]).
  ///   Subsequent runs of the animation are cheaper for the CPU but not for the GPU.
  ///   Memory usage is a lot lower than RenderCache.raster.
  ///
  /// The render cache is managed internally and will release the memory once the
  /// animation disappear. The cache is shared between all animations.

  /// Any change in the configuration of the animation (delegates, frame rate etc...)
  /// will clear the cache entry.
  /// For RenderCache.raster, any change in the size will invalidate the cache entry. The cache
  /// use the final size visible on the screen (with all transforms applied).
  ///
  /// In order to not exceed the memory limit of a device, the raster cache is constrained
  /// to maximum 50MB. After that, animations are not cached anymore.
  final RenderCache? renderCache;

  const LottieConfig({
    this.onLoaded,
    this.controller,
    this.frameRate,
    this.animate,
    this.repeat,
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
  });
}
