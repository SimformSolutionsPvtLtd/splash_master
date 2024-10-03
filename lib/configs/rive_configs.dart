import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveConfig {
  const RiveConfig({
    this.name,
    this.file,
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.useArtboardSize = false,
    this.clipRect,
    this.controllers = const [],
    this.onInit,
    this.objectGenerator,
    this.behavior = RiveHitTestBehavior.opaque,
  })  : headers = null,
        loadCdnAssets = true,
        assetLoader = null;

  const RiveConfig.network({
    this.name,
    this.file,
    this.artboard,
    this.animations = const [],
    this.stateMachines = const [],
    this.fit,
    this.alignment,
    this.placeHolder,
    this.antialiasing = true,
    this.useArtboardSize = false,
    this.clipRect,
    this.controllers = const [],
    this.onInit,
    this.objectGenerator,
    this.behavior = RiveHitTestBehavior.opaque,
    this.headers,
  })  : assetLoader = null,
        loadCdnAssets = true;

  const RiveConfig.bytes({
    this.assetLoader,
    this.objectGenerator,
    this.loadCdnAssets = true,
  })  : name = null,
        file = null,
        artboard = null,
        animations = const [],
        stateMachines = const [],
        fit = null,
        alignment = null,
        placeHolder = null,
        antialiasing = false,
        useArtboardSize = false,
        clipRect = null,
        controllers = const [],
        onInit = null,
        behavior = RiveHitTestBehavior.opaque,
        headers = null;

  /// The asset name or url
  final String? name;

  /// The Rive File object
  final RiveFile? file;

  /// The name of the artboard to use; default artboard if not specified
  final String? artboard;

  /// List of animations to play; default animation if not specified
  final List<String> animations;

  /// List of state machines to play; none will play if not specified
  final List<String> stateMachines;

  /// Fit for the animation in the widget
  final BoxFit? fit;

  /// Alignment for the animation in the widget
  final Alignment? alignment;

  /// Widget displayed while the rive is loading
  final Widget? placeHolder;

  /// Enable/disable antialiasing when rendering
  final bool antialiasing;

  /// {@macro Rive.useArtboardSize}
  final bool useArtboardSize;

  /// {@macro Rive.clipRect}
  final Rect? clipRect;

  /// Controllers for instanced animations and state machines; use this
  /// to directly control animation states instead of passing names.
  final List<RiveAnimationController> controllers;

  /// Callback fired when [RiveAnimation] has initialized
  final OnInitCallback? onInit;

  /// Headers for network requests
  final Map<String, String>? headers;

  /// {@macro Rive.behavior}
  final RiveHitTestBehavior behavior;

  /// Rive object generator to override built-in types and methods to, for
  /// example, interject custom rendering functionality interleaved with Rive
  /// rendering.
  final ObjectGenerator? objectGenerator;

  final FileAssetLoader? assetLoader;

  final bool loadCdnAssets;
}
