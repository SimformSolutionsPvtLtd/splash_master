abstract final class DesktopStrings {
  static const String kEmptyString = '';
  static const String closingBracket = '}';

  /// ------ macOS paths---------
  static const String macos = 'macos';
  static const String runner = 'Runner';
  static const String assetsDir = 'Assets.xcassets';
  static const String contentsJsonFileName = 'Contents.json';
  static const String appDelegateFileName = 'AppDelegate.swift';
  static const String mainFlutterWindowFileName = 'MainFlutterWindow.swift';
  static const String imagesetExtension = '.imageset';
  static const String colorsetExtension = '.colorset';

  static const String xcassetsDirPath = '$macos/$runner/$assetsDir';
  static const String appDelegateFilePath =
      '$macos/$runner/$appDelegateFileName';
  static const String mainFlutterWindowFilePath =
      '$macos/$runner/$mainFlutterWindowFileName';

  /// ------ Asset catalog names and file names --------
  static const String splashImageAssetName = 'SplashImage';
  static const String brandingImageAssetName = 'BrandingImage';
  static const String splashBackgroundColorAssetName = 'SplashBackgroundColor';

  // Splash image file names
  static const String splashImage1x = 'splash.png';
  static const String splashImage2x = 'splash@2x.png';
  static const String splashImage3x = 'splash@3x.png';
  static const String splashImageDark1x = 'splash_dark.png';
  static const String splashImageDark2x = 'splash_dark@2x.png';
  static const String splashImageDark3x = 'splash_dark@3x.png';

  // Branding image file names
  static const String brandingImage1x = 'branding.png';
  static const String brandingImage2x = 'branding@2x.png';
  static const String brandingImage3x = 'branding@3x.png';
  static const String brandingImageDark1x = 'branding_dark.png';
  static const String brandingImageDark2x = 'branding_dark@2x.png';
  static const String brandingImageDark3x = 'branding_dark@3x.png';

  // Asset catalog idioms, scales, appearances, color spaces, and author
  static const String idiomUniversal = 'universal';
  static const String scale1x = '1x';
  static const String scale2x = '2x';
  static const String scale3x = '3x';
  static const String appearanceKey = 'appearance';
  static const String valueKey = 'value';
  static const String appearanceLuminosity = 'luminosity';
  static const String appearanceDark = 'dark';
  static const String colorSpaceSRGB = 'srgb';
  static const String assetCatalogAuthor = 'xcode';
  static const int assetCatalogVersion = 1;

  static const int defaultBrandingSpacing = 20;
  static const int defaultSplashWindowWidth = 800;
  static const int defaultSplashWindowHeight = 600;
  static const int defaultMainWindowWidth = 800;
  static const int defaultMainWindowHeight = 600;
  static const bool defaultMacosBorderless = false;

  // Default values for desktop enums
  static const String imageFitDefaultValue = 'contain';
  static const String imagePositionDefaultValue = 'center';
  static const String brandingPositionDefaultValue = 'bottomCenter';

  // Markers for generated code in MainFlutterWindow.swift
  static const String kBeginMarker = '// BEGIN:SPLASH_MASTER_GENERATED';
  static const String kEndMarker = '// END:SPLASH_MASTER_GENERATED';

  // Method channel names and method names for macOS native splash
  static const String macosSplashMethodChannelName = 'macos_splash';
  static const String macosRemoveSplashMethodName = 'removeSplash';

  ///-------- Code snippets for AppDelegate and MainFlutterWindow modifications --------
  static const String applicationDidFinishLaunchingSuperCall =
      'super.applicationDidFinishLaunching(notification)';

  static const String applicationDidFinishLaunchingMethodSignature =
      'override func applicationDidFinishLaunching(_ notification: Notification)';

  static const String macosMethodChannelTemplate = '''
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "$macosSplashMethodChannelName",
        binaryMessenger: controller.engine.binaryMessenger
      )

      channel.setMethodCallHandler { [weak self] call, result in
        if call.method == "$macosRemoveSplashMethodName" {
          (self?.mainFlutterWindow as? MainFlutterWindow)?.$macosRemoveSplashMethodName()
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
''';

  static const String applicationDidFinishLaunchingFunctionTemplate = '''
      $applicationDidFinishLaunchingMethodSignature {
        $macosMethodChannelTemplate
        $applicationDidFinishLaunchingSuperCall
      }
    ''';

  static const String mainFileScaffoldTemplate = '''
import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {

''';

  static const String splashImageTemplate = '''
    let imageView = NSImageView()
    imageView.image = NSImage(named: "SplashImage")
    imageView.translatesAutoresizingMaskIntoConstraints = false''';

  static const String addSubviewTemplate = 'container.addSubview(imageView)\n';

  static const String brandingImageTemplate = '''
    let brandingView = NSImageView()
    brandingView.image = NSImage(named: "BrandingImage")
    brandingView.imageScaling = .scaleProportionallyDown
    brandingView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    brandingView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    brandingView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    brandingView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    brandingView.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(brandingView)''';

  static const String borderlessOnTemplate = '''
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.styleMask.remove(.titled)
    self.styleMask.insert(.fullSizeContentView)''';

  static const String borderlessOffTemplate = '''
    self.titleVisibility = .visible
    self.titlebarAppearsTransparent = false
    self.styleMask.insert(.titled)
    self.styleMask.remove(.fullSizeContentView)
''';

  static const String awakeFromNibWithoutSplashTemplate =
      '  override func awakeFromNib() {\n'
      '    let flutterViewController = FlutterViewController()\n'
      '    self.contentViewController = flutterViewController\n'
      '    if let bgColor = NSColor(named: "$splashBackgroundColorAssetName") {\n'
      '      flutterViewController.backgroundColor = bgColor\n'
      '    }\n'
      '\n'
      '    let screen = NSScreen.main ?? NSScreen.screens[0]\n'
      '    let screenFrame = screen.visibleFrame\n'
      '    let origin = NSPoint(\n'
      '      x: screenFrame.midX - _mainSize.width / 2,\n'
      '      y: screenFrame.midY - _mainSize.height / 2\n'
      '    )\n'
      '    self.setFrame(NSRect(origin: origin, size: _mainSize), display: true)\n'
      '\n'
      '    RegisterGeneratedPlugins(registry: flutterViewController)\n'
      '    super.awakeFromNib()\n'
      '  }\n';

  static const String addSplashViewOpeningTemplate =
      '  private func _addSplashView() {\n'
      '    guard let contentView = self.contentView else { return }\n'
      '\n'
      '    let container = NSView(frame: contentView.bounds)\n'
      '    container.autoresizingMask = [.width, .height]\n'
      '    container.wantsLayer = true\n'
      '\n'
      '    if let bgColor = NSColor(named: "$splashBackgroundColorAssetName") {\n'
      '      container.layer?.backgroundColor = bgColor.cgColor\n'
      '    }\n';

  static const String addSplashViewClosingTemplate = '\n'
      '    contentView.addSubview(container, positioned: .above, relativeTo: nil)\n'
      '    _splashContainer = container\n';

  static const String removeSplashTemplate = '  func removeSplash() {\n'
      '    guard let splashView = _splashContainer else { return }\n'
      '    NSAnimationContext.runAnimationGroup { context in\n'
      '      context.duration = 0.3\n'
      '      splashView.animator().alphaValue = 0\n'
      '    } completionHandler: {\n'
      '      splashView.removeFromSuperview()\n'
      '      self._splashContainer = nil\n'
      '    }\n'
      '\n'
      '    if(_splashSize != _mainSize) {\n'
      '      let screen = NSScreen.main ?? NSScreen.screens[0]\n'
      '      let screenFrame = screen.visibleFrame\n'
      '      let origin = NSPoint(\n'
      '        x: screenFrame.midX - _mainSize.width / 2,\n'
      '        y: screenFrame.midY - _mainSize.height / 2\n'
      '      )\n'
      '      self.setFrame(NSRect(origin: origin, size: _mainSize), display: true, animate: false)\n'
      '    }\n';

  static const String awakeFromNibSplashTemplate =
      '  override func awakeFromNib() {\n'
      '    let flutterViewController = FlutterViewController()\n'
      '    self.contentViewController = flutterViewController\n'
      '    if let bgColor = NSColor(named: "$splashBackgroundColorAssetName") {\n'
      '      flutterViewController.backgroundColor = bgColor\n'
      '    }\n'
      '\n'
      '    let screen = NSScreen.main ?? NSScreen.screens[0]\n'
      '    let screenFrame = screen.visibleFrame\n'
      '    let origin = NSPoint(\n'
      '      x: screenFrame.midX - _splashSize.width / 2,\n'
      '      y: screenFrame.midY - _splashSize.height / 2\n'
      '    )\n'
      '    self.setFrame(NSRect(origin: origin, size: _splashSize), display: true)\n'
      '\n'
      '    _addSplashView()\n'
      '    RegisterGeneratedPlugins(registry: flutterViewController)\n'
      '    super.awakeFromNib()\n'
      '  }\n';
}
