enum Command {
  install,
  build,
  none;

  static Command fromString(String str) => switch (str) {
        'install' => install,
        'build' => build,
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

enum IosScale {
  oneX(
    width: 1080,
    height: 1920,
    fileEndWith: '',
    scale: '1x',
  ),
  twoX(
    width: 1080,
    height: 1920,
    fileEndWith: '@2x',
    scale: '2x',
  ),
  threeX(
    width: 1080,
    height: 1920,
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
