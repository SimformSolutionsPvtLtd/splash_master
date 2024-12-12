class YamlKeys {
  /// [splashMasterKey] is used to specify the `splash_master` section in `pubspec.yaml`.
  static const splashMasterKey = 'splash_master';

  /// Specifies the splash image.
  static const imageKey = 'image';

  /// Specifies the color in splash screen.
  static const colorKey = 'color';

  /// Specifies the gravity for splash image in the Android.
  static const androidGravityKey = 'android_gravity';

  /// Specifies the content mode for splash image in the iOS.
  static const iosContentModeKey = 'ios_content_mode';

  /// Specifies splash screen setup details for Android 12.
  static const android12key = 'android_12';

  /// List of supported keys
  static List<String> supportedYamlKeys = [
    imageKey,
    colorKey,
    androidGravityKey,
    iosContentModeKey,
    android12key,
  ];
}
