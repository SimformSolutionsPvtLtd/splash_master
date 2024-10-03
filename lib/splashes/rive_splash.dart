import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:splash_master/configs/rive_configs.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';

class RiveSplash extends StatelessWidget {
  const RiveSplash({
    super.key,
    required this.source,
    this.riveConfigs = const RiveConfig(),
  });

  final Source source;
  final RiveConfig riveConfigs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getRiveAnimationFromSource(),
    );
  }

  Widget getRiveAnimationFromSource() {
    switch (source) {
      case AssetSource assetSource:
        return RiveAnimation.asset(
          assetSource.path,
          alignment: riveConfigs.alignment,
          behavior: riveConfigs.behavior,
          onInit: riveConfigs.onInit,
          fit: riveConfigs.fit,
          animations: riveConfigs.animations,
          antialiasing: riveConfigs.antialiasing,
          artboard: riveConfigs.artboard,
          clipRect: riveConfigs.clipRect,
          controllers: riveConfigs.controllers,
          objectGenerator: riveConfigs.objectGenerator,
          placeHolder: riveConfigs.placeHolder,
          stateMachines: riveConfigs.stateMachines,
          useArtboardSize: riveConfigs.useArtboardSize,
        );
      case NetworkFileSource networkFileSource:
        return RiveAnimation.network(
          networkFileSource.url.toString(),
          alignment: riveConfigs.alignment,
          behavior: riveConfigs.behavior,
          onInit: riveConfigs.onInit,
          fit: riveConfigs.fit,
          animations: riveConfigs.animations,
          antialiasing: riveConfigs.antialiasing,
          artboard: riveConfigs.artboard,
          clipRect: riveConfigs.clipRect,
          controllers: riveConfigs.controllers,
          objectGenerator: riveConfigs.objectGenerator,
          placeHolder: riveConfigs.placeHolder,
          stateMachines: riveConfigs.stateMachines,
          useArtboardSize: riveConfigs.useArtboardSize,
          headers: riveConfigs.headers,
        );
      case DeviceFileSource deviceFileSource:
        return RiveAnimation.file(
          deviceFileSource.file.path,
          alignment: riveConfigs.alignment,
          behavior: riveConfigs.behavior,
          onInit: riveConfigs.onInit,
          fit: riveConfigs.fit,
          animations: riveConfigs.animations,
          antialiasing: riveConfigs.antialiasing,
          artboard: riveConfigs.artboard,
          clipRect: riveConfigs.clipRect,
          controllers: riveConfigs.controllers,
          objectGenerator: riveConfigs.objectGenerator,
          placeHolder: riveConfigs.placeHolder,
          stateMachines: riveConfigs.stateMachines,
          useArtboardSize: riveConfigs.useArtboardSize,
        );
      case BytesSource bytesSource:
        return RiveAnimation.direct(
          RiveFile.import(
            bytesSource.bytes.buffer.asByteData(),
            assetLoader: riveConfigs.assetLoader,
            loadCdnAssets: riveConfigs.loadCdnAssets,
            objectGenerator: riveConfigs.objectGenerator,
          ),
        );
      case RiveWidgetSource riveWidgetSource:
        return riveWidgetSource.rive;
      default:
        throw SplashMasterException(message: "Unknown Source");
    }
  }
}
