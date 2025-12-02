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
/// Note: This configuration is designed for Rive 0.14.x which uses a completely
/// new C++ runtime-based API. Many parameters from the previous Rive versions
/// have been replaced with new equivalents.
class RiveConfig {
  /// The selector to specify which artboard to use.
  ///
  /// Defaults to [ArtboardSelector.byDefault()] which uses the default artboard.
  /// You can also use:
  /// - [ArtboardSelector.byName(name)] to select by artboard name
  /// - [ArtboardSelector.byIndex(index)] to select by index
  final ArtboardSelector artboardSelector;

  /// The selector to specify which state machine to use.
  ///
  /// Defaults to [StateMachineSelector.byDefault()] which uses the default state machine.
  /// You can also use:
  /// - [StateMachineSelector.byName(name)] to select by state machine name
  /// - [StateMachineSelector.byIndex(index)] to select by index
  final StateMachineSelector stateMachineSelector;

  /// Controls how the animation fits within its bounds.
  ///
  /// Note: In Rive 0.14.x, this uses the Rive [Fit] enum instead of Flutter's [BoxFit].
  final Fit fit;

  /// Alignment of the animation within its bounds
  final Alignment alignment;

  /// Called when the Rive file is loaded and ready to be displayed.
  ///
  /// Provides the [RiveWidgetController] which can be used to access the
  /// artboard and state machine.
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

  /// The Rive factory to use.
  ///
  /// Defaults to [Factory.rive] which uses the Rive Renderer.
  /// Can be set to [Factory.flutter] to use the Flutter renderer.
  /// If null, defaults to [Factory.rive].
  final Factory? riveFactory;

  /// The data bind to specify which view model instance to bind to.
  ///
  /// Use [DataBind.auto()] to auto-bind, [DataBind.byName(name)] to bind by
  /// name, [DataBind.byIndex(index)] to bind by index, or
  /// [DataBind.byInstance(instance)] to bind to a specific instance.
  final DataBind? dataBind;

  /// An optional function to manually create the controller instead of using
  /// the default one.
  ///
  /// Receives the loaded [File] and must return a [RiveWidgetController].
  /// Use this for advanced controller customization.
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
