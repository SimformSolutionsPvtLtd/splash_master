enum Command {
  install,
  build,
  none;

  static Command fromString(String str) =>
      switch (str) { 'install' => install, 'build' => build, _ => none };
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
