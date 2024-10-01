import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash_master/config/lottie_config.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';

class LottieSplash extends StatefulWidget {
  const LottieSplash({
    super.key,
    required this.source,
    this.lottieConfig = const LottieConfig(),
  });

  final Source source;
  final LottieConfig lottieConfig;

  @override
  State<LottieSplash> createState() => _LottieSplashState();
}

class _LottieSplashState extends State<LottieSplash> {
  @override
  Widget build(BuildContext context) {
    final lottieConfig = widget.lottieConfig;
    return Scaffold(
      body: Center(
        child: LottieBuilder(
          lottie: getLottieFromSource(widget.source),
          controller: lottieConfig.controller,
          frameRate: lottieConfig.frameRate,
          animate: lottieConfig.animate,
          reverse: lottieConfig.reverse,
          repeat: lottieConfig.repeat,
          delegates: lottieConfig.delegates,
          options: lottieConfig.options,
          onLoaded: lottieConfig.onLoaded,
          errorBuilder: lottieConfig.errorBuilder,
          width: lottieConfig.width,
          height: lottieConfig.height,
          fit: lottieConfig.fit,
          alignment: lottieConfig.alignment,
          addRepaintBoundary: lottieConfig.addRepaintBoundary,
          filterQuality: lottieConfig.filterQuality,
          onWarning: lottieConfig.onWarning,
          renderCache: lottieConfig.renderCache,
        ),
      ),
    );
  }

  LottieProvider getLottieFromSource(Source source) {
    switch (source) {
      case AssetSource assetSource:
        return AssetLottie(assetSource.path);
      case DeviceFileSource deviceFileSource:
        return FileLottie(deviceFileSource.file);
      case NetworkFileSource networkFileSource:
        return NetworkLottie(networkFileSource.path);
      case BytesSource bytesSource:
        return MemoryLottie(bytesSource.bytes);
      default:
        throw SplashMasterException(message: 'Unknown source found.');
    }
  }
}
