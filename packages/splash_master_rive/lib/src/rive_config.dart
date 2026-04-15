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
///
/// Note: This configuration targets Rive 0.14.x APIs.
class RiveConfig {
  /// The selector to specify which artboard to use.
  final ArtboardSelector artboardSelector;

  /// The selector to specify which state machine to use.
  final StateMachineSelector stateMachineSelector;

  /// Controls how the animation fits within its bounds.
  ///
  /// Uses Rive's [Fit] enum in 0.14.x.
  final Fit fit;

  /// Alignment of the animation within its bounds
  final Alignment alignment;

  /// Called when the Rive file is loaded and ready to be displayed.
  final void Function(RiveWidgetController)? onInit;

  /// Whether to use a SafeArea widget
  final bool useSafeArea;

  /// Defines the behavior when hit testing the Rive animation
  final RiveHitTestBehavior hitTestBehavior;

  /// The cursor to show when hovering over the animation
  final MouseCursor cursor;

  /// The layout scale factor of the artboard when using [Fit.layout].
  final double layoutScaleFactor;

  /// A widget to display as a placeholder while the Rive animation is loading
  final Widget? placeHolder;

  /// Duration for which the splash will be visible for Rive animations.
  /// If provided, uses this value; otherwise defaults to 3 seconds.
  final Duration? splashDuration;

  /// The Rive factory to use. Defaults to [Factory.rive] at runtime.
  final Factory? riveFactory;

  /// Optional data bind selector for view model binding.
  final DataBind? dataBind;

  /// Optional controller factory to override the default controller.
  final Controller? controller;

  /// Creates a configuration for Rive animation splash screens
  const RiveConfig({
    this.artboardSelector = const ArtboardDefault(),
    this.stateMachineSelector = const StateMachineDefault(),
    this.fit = Fit.contain,
    this.alignment = Alignment.center,
    this.onInit,
    this.useSafeArea = false,
    this.hitTestBehavior = RiveHitTestBehavior.opaque,
    this.cursor = MouseCursor.defer,
    this.layoutScaleFactor = 1.0,
    this.placeHolder,
    this.splashDuration,
    this.riveFactory,
    this.dataBind,
    this.controller,
  });
}
