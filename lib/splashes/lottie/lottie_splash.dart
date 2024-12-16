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
import 'package:splash_master/core/source.dart';
import 'package:splash_master/core/utils.dart';
import 'package:splash_master/splashes/lottie/lottie_config.dart';
import 'package:splash_master/splashes/video/video_config.dart';

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
        child: _lottieMediaWidget(context),
      ),
    );
  }

  Widget _lottieMediaWidget(BuildContext context) {
    switch (lottieConfig.visibilityEnum) {
      case VisibilityEnum.useFullScreen:
        return SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: lottieWidget,
        );
      case VisibilityEnum.useAspectRatio:
        return AspectRatio(
          aspectRatio: lottieConfig.aspectRatio,
          child: lottieWidget,
        );
      case VisibilityEnum.none:
        return lottieWidget;
    }
  }

  Widget get lottieWidget {
    return LottieBuilder(
      lottie: _getLottieFromSource(),
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

  LottieProvider _getLottieFromSource() {
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
