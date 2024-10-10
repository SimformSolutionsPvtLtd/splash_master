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
  oneX(1080, 1920, '', '1x'),
  twoX(1080, 1920, '@2x', '2x'),
  threeX(1080, 1920, '@3x', '3x');

  final String fileEndWith;
  final String scale;
  final double height;
  final double width;

  const IosScale(this.width, this.height, this.fileEndWith, this.scale);
}
