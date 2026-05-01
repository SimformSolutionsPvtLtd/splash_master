/// Data model for Windows splash screen asset paths.
///
/// This DM holds the relative paths to the splash and branding images
/// for both light and dark themes on Windows. These paths are used to
/// locate the assets in the Windows runner resources directory.
class WindowsSplashAssetPathsDm {
  const WindowsSplashAssetPathsDm({
    this.imageRelativePath,
    this.imageDarkRelativePath,
    this.brandingImageRelativePath,
    this.brandingImageDarkRelativePath,
  });

  final String? imageRelativePath;
  final String? imageDarkRelativePath;
  final String? brandingImageRelativePath;
  final String? brandingImageDarkRelativePath;
}
