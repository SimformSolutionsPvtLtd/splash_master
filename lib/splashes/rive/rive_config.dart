/*
 * Copyright (c) 2025 Simform Solutions
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
import 'package:rive/rive.dart';

/// Configuration class for Rive animation splash screens
class RiveConfig {
  /// The name of the animation state machine to play
  final List<String> stateMachineName;

  /// The name of the animation to play
  final List<String> animations;

  /// The name of the artboard to use
  final String? artboardName;

  /// Controls how the animation fits within its bounds
  final BoxFit fit;

  /// Whether to play animation automatically
  final bool autoplay;

  /// Alignment of the animation within its bounds
  final Alignment alignment;

  /// Use this to provide custom controllers for the Rive animation
  final List<RiveAnimationController> controllers;

  /// Called when the Rive file is loaded and ready to be displayed
  final void Function(Artboard)? onInit;

  /// Called when there's a playback state change

  /// Whether to use a SafeArea widget
  final bool useSafeArea;

  /// Custom asset loader for loading Rive assets
  ///
  /// This allows loading assets from custom sources not supported by default loaders
  final FileAssetLoader? assetLoader;

  /// Whether to load CDN assets referenced within the Rive file
  ///
  /// Set to false to skip loading external assets if the Rive file references them
  final bool loadCdnAssets;

  /// Factory function for creating custom Core objects
  ///
  /// This allows for more advanced customization of the Rive runtime
  final ObjectGenerator? objectGenerator;

  /// Rectangle used to clip the animation
  final Rect? clipRect;

  /// Controls if the animation responds to touch scroll events
  final bool isTouchScrollEnabled;

  /// Multiplier for animation playback speed
  final double speedMultiplier;

  /// Defines the behavior when hit testing the Rive animation
  final RiveHitTestBehavior behavior;

  /// Whether to use the artboard's dimensions for layout
  final bool useArtboardSize;

  /// Controls if antialiasing is applied to the animation
  final bool antialiasing;

  /// Controls if pointer events are enabled for the animation
  final bool enablePointerEvents;

  /// The cursor to show when hovering over the animation
  final MouseCursor cursor;

  /// HTTP headers to use when fetching animation from network
  final Map<String, String>? headers;

  /// A widget to display as a placeholder while the Rive animation is loading
  final Widget? placeHolder;

  /// Duration for which the splash will be visible for Rive animations.
  /// If provided, this overrides the automatic duration calculation.
  final Duration? splashDuration;

  /// Creates a configuration for Rive animation splash screens
  const RiveConfig({
    this.stateMachineName = const [],
    this.animations = const [],
    this.artboardName,
    this.fit = BoxFit.contain,
    this.autoplay = true,
    this.alignment = Alignment.center,
    this.controllers = const [],
    this.onInit,
    this.useSafeArea = false,
    this.assetLoader,
    this.loadCdnAssets = true,
    this.objectGenerator,
    this.clipRect,
    this.isTouchScrollEnabled = false,
    this.speedMultiplier = 1,
    this.behavior = RiveHitTestBehavior.opaque,
    this.useArtboardSize = false,
    this.antialiasing = true,
    this.enablePointerEvents = false,
    this.cursor = MouseCursor.defer,
    this.headers,
    this.placeHolder,
    this.splashDuration,
  });
}
