import 'package:flutter/material.dart';
import 'package:splash_master/configs/image_config.dart';
import 'package:splash_master/core/source.dart';

class ImageSplash extends StatefulWidget {
  const ImageSplash({
    super.key,
    required this.source,
    this.imageConfig = const ImageConfig(),
  });

  final Source source;
  final ImageConfig imageConfig;

  @override
  State<ImageSplash> createState() => _ImageSplashState();
}

class _ImageSplashState extends State<ImageSplash> {
  ImageConfig get imageConfig => widget.imageConfig;

  @override
  Widget build(BuildContext context) {
    return getImageFromSource();
  }

  Widget getImageFromSource() {
    switch (widget.source) {
      case AssetSource assetSource:
        return Image.asset(
          assetSource.path,
          fit: imageConfig.fit,
          frameBuilder: imageConfig.frameBuilder,
          alignment: imageConfig.alignment,
          height: imageConfig.height,
          width: imageConfig.width,
          scale: imageConfig.scale,
          opacity: imageConfig.opacity,
          color: imageConfig.color,
          errorBuilder: imageConfig.errorBuilder,
          filterQuality: imageConfig.filterQuality,
          gaplessPlayback: imageConfig.gaplessPlayback,
          isAntiAlias: imageConfig.isAntiAlias,
          centerSlice: imageConfig.centerSlice,
          colorBlendMode: imageConfig.colorBlendMode,
          semanticLabel: imageConfig.semanticLabel,
          repeat: imageConfig.repeat,
          matchTextDirection: imageConfig.matchTextDirection,
          excludeFromSemantics: imageConfig.excludeFromSemantics,
          cacheWidth: imageConfig.cacheWidth,
          cacheHeight: imageConfig.cacheHeight,
          package: imageConfig.package,
          bundle: imageConfig.bundle,
        );
      case DeviceFileSource deviceFileSource:
        return Image.file(
          deviceFileSource.file,
          fit: imageConfig.fit,
          frameBuilder: imageConfig.frameBuilder,
          alignment: imageConfig.alignment,
          height: imageConfig.height,
          width: imageConfig.width,
          scale: imageConfig.scale ?? 1,
          opacity: imageConfig.opacity,
          color: imageConfig.color,
          errorBuilder: imageConfig.errorBuilder,
          filterQuality: imageConfig.filterQuality,
          gaplessPlayback: imageConfig.gaplessPlayback,
          isAntiAlias: imageConfig.isAntiAlias,
          centerSlice: imageConfig.centerSlice,
          colorBlendMode: imageConfig.colorBlendMode,
          semanticLabel: imageConfig.semanticLabel,
          repeat: imageConfig.repeat,
          matchTextDirection: imageConfig.matchTextDirection,
          excludeFromSemantics: imageConfig.excludeFromSemantics,
          cacheWidth: imageConfig.cacheWidth,
          cacheHeight: imageConfig.cacheHeight,
        );
      case NetworkFileSource networkFileSource:
        return Image.network(
          networkFileSource.path,
          fit: imageConfig.fit,
          frameBuilder: imageConfig.frameBuilder,
          alignment: imageConfig.alignment,
          height: imageConfig.height,
          width: imageConfig.width,
          scale: imageConfig.scale ?? 1,
          opacity: imageConfig.opacity,
          color: imageConfig.color,
          errorBuilder: imageConfig.errorBuilder,
          filterQuality: imageConfig.filterQuality,
          gaplessPlayback: imageConfig.gaplessPlayback,
          isAntiAlias: imageConfig.isAntiAlias,
          centerSlice: imageConfig.centerSlice,
          colorBlendMode: imageConfig.colorBlendMode,
          semanticLabel: imageConfig.semanticLabel,
          repeat: imageConfig.repeat,
          matchTextDirection: imageConfig.matchTextDirection,
          excludeFromSemantics: imageConfig.excludeFromSemantics,
          cacheWidth: imageConfig.cacheWidth,
          cacheHeight: imageConfig.cacheHeight,
          headers: imageConfig.headers,
          loadingBuilder: imageConfig.loadingBuilder,
        );
      case BytesSource bytesSource:
        return Image.memory(
          bytesSource.bytes,
          fit: imageConfig.fit,
          frameBuilder: imageConfig.frameBuilder,
          alignment: imageConfig.alignment,
          height: imageConfig.height,
          width: imageConfig.width,
          scale: imageConfig.scale ?? 1,
          opacity: imageConfig.opacity,
          color: imageConfig.color,
          errorBuilder: imageConfig.errorBuilder,
          filterQuality: imageConfig.filterQuality,
          gaplessPlayback: imageConfig.gaplessPlayback,
          isAntiAlias: imageConfig.isAntiAlias,
          centerSlice: imageConfig.centerSlice,
          colorBlendMode: imageConfig.colorBlendMode,
          semanticLabel: imageConfig.semanticLabel,
          repeat: imageConfig.repeat,
          matchTextDirection: imageConfig.matchTextDirection,
          excludeFromSemantics: imageConfig.excludeFromSemantics,
          cacheWidth: imageConfig.cacheWidth,
          cacheHeight: imageConfig.cacheHeight,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
