import 'package:flutter/material.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';

class SplashController {
  SplashController({required this.splashMediaType, required this.source});

  final SplashMediaType splashMediaType;

  final Source source;

  void getMediaWidget() {
    switch (splashMediaType) {
      case SplashMediaType.image:
      // TODO: Handle this case.
      case SplashMediaType.video:
      // TODO: Handle this case.
      case SplashMediaType.lottie:
      // TODO: Handle this case.
      case SplashMediaType.rive:
      // TODO: Handle this case.
      case SplashMediaType.custom:
      // TODO: Handle this case.
    }
  }

  Widget getImageFromSource() {
    switch (source) {
      case AssetSource assetSource:
        return Image.asset(assetSource.path);
      case DeviceFileSource deviceFileSource:
        return Image.file(deviceFileSource.file);
      case NetworkFileSource networkFileSource:
        return Image.network(networkFileSource.path);
      case BytesSource bytesSource:
        return Image.memory(bytesSource.bytes);
      default:
        return const SizedBox.shrink();
    }
  }
}
