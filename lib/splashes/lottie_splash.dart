import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash_master/configs/lottie_config.dart';
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';

class LottieSplash extends StatelessWidget {
  const LottieSplash({
    super.key,
    required this.source,
    this.lottieConfig = const LottieConfig(),
    this.onSplashDuration,
  });

  final Source source;
  final LottieConfig lottieConfig;
  final OnSplashDuration? onSplashDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lottieConfig.backgroundColor,
      body: Center(
        child: lottieConfig.useAspectRatio
            ? AspectRatio(
                aspectRatio: lottieConfig.aspectRatio,
                child: lottieWidget,
              )
            : lottieConfig.useFullScreen
                ? SizedBox.fromSize(
                    size: MediaQuery.sizeOf(context),
                    child: lottieWidget,
                  )
                : lottieWidget,
      ),
    );
  }

  Widget get lottieWidget {
    return LottieBuilder(
      lottie: getLottieFromSource(source),
      controller: lottieConfig.controller,
      frameRate: lottieConfig.frameRate,
      animate: lottieConfig.animate,
      reverse: lottieConfig.reverse,
      repeat: lottieConfig.repeat,
      delegates: lottieConfig.delegates,
      options: lottieConfig.options,
      onLoaded: (composition) {
        onSplashDuration?.call(composition.duration);
        lottieConfig.onLoaded?.call(composition);
      },
      errorBuilder: lottieConfig.errorBuilder,
      width: lottieConfig.width,
      height: lottieConfig.height,
      fit: lottieConfig.overrideBoxFit ? BoxFit.fill : lottieConfig.fit,
      alignment: lottieConfig.alignment,
      addRepaintBoundary: lottieConfig.addRepaintBoundary,
      filterQuality: lottieConfig.filterQuality,
      onWarning: lottieConfig.onWarning,
      renderCache: lottieConfig.renderCache,
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
