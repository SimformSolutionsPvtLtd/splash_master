enum Command {
  create,
  none;

  static Command fromString(String str) => switch (str) {
        'create' => create,
        _ => none,
      };
}

enum AndroidMipMaps {
  mdpi(320, 480, 'mipmap-mdpi'),
  hdpi(480, 800, 'mipmap-hdpi'),
  xhdpi(720, 1280, 'mipmap-xhdpi'),
  xxhdpi(960, 1600, 'mipmap-xxhdpi'),
  xxxhdpi(1280, 1920, 'mipmap-xxxhdpi');

  final double height;
  final double width;
  final String folder;

  const AndroidMipMaps(this.width, this.height, this.folder);
}

/// Scales are set according to latest [Apple guidelines](https://developer.apple.com/design/human-interface-guidelines/layout#Specifications)
/// on 21/10/2024 for iPhone.
enum IosScale {
  oneX(
    width: 320,
    height: 480,
    fileEndWith: '',
    scale: '1x',
  ),
  twoX(
    width: 828,
    height: 1792,
    fileEndWith: '@2x',
    scale: '2x',
  ),
  threeX(
    width: 1320,
    height: 2868,
    fileEndWith: '@3x',
    scale: '3x',
  );

  final String fileEndWith;
  final String scale;
  final double height;
  final double width;

  const IosScale({
    required this.width,
    required this.height,
    required this.fileEndWith,
    required this.scale,
  });
}
