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

import '../../splash_master.dart';

/// Supported image extensions
enum SupportedImageExtensions {
  jpg,
  png,
  jpeg;
}

/// All the available Android gravity values
enum AndroidGravity {
  center,
  clipHorizontal,
  clipVertical,
  fillHorizontal,
  fill,
  centerVertical,
  bottom,
  fillVertical,
  centerHorizontal,
  top,
  end,
  left,
  right,
  start;

  /// Returns true if the provided string is a valid [AndroidGravity] value.
  static bool isSupported(String? str) {
    if (str.isNullOrBlank) return false;
    return values.any((supported) => supported.name == str);
  }
}

/// All the available iOS content mode values
enum IosContentMode {
  scaleToFill,
  scaleAspectFit,
  scaleAspectFill,
  redraw,
  center,
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  /// Returns true if the provided string is a valid [IosContentMode] value.
  static bool isSupported(String? str) {
    if (str.isNullOrBlank) return false;
    return values.any((supported) => supported.name == str);
  }
}

/// All the available image fit values for desktop splash configuration.
enum DesktopImageFit {
  contain,
  cover,
  fill,
  fitWidth,
  fitHeight,
  none,
  scaleDown;

  /// Converts the enum value to the corresponding macOS image scaling code for the splash image.
  String get toMacosScalingLine => switch (this) {
        contain => '''
      imageView.imageScaling = .scaleProportionallyUpOrDown
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)''',
        fill => '''
      imageView.imageScaling = .scaleAxesIndependently
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)''',
        fitWidth || fitHeight => '''
      imageView.imageScaling = .scaleProportionallyUpOrDown
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)''',
        none => 'imageView.imageScaling = .scaleNone',
        scaleDown => '''
      imageView.imageScaling = .scaleProportionallyDown
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)''',
        cover => '''
      imageView.imageScaling = .scaleProportionallyUpOrDown
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
      imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
      imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
      imageView.wantsLayer = true
      imageView.layer?.masksToBounds = true''',
      };

  /// Constraints that must go inside NSLayoutConstraint.activate([]).
  String get toMacosDimensionConstraints => switch (this) {
        fitWidth => '''
      imageView.widthAnchor.constraint(equalTo: container.widthAnchor),
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),''',
        fitHeight => '''
      imageView.heightAnchor.constraint(equalTo: container.heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),''',
        cover || fill => '''
      imageView.widthAnchor.constraint(equalTo: container.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: container.heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),''',
        contain => '''
      imageView.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor),
      imageView.heightAnchor.constraint(lessThanOrEqualTo: container.heightAnchor),
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),''',
        none || scaleDown => '''
      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),''',
      };

  /// Returns true if the provided string is a valid [DesktopImageFit] value.
  static bool isSupported(String? str) {
    if (str.isNullOrBlank) return false;
    return values.any((supported) => supported.name == str);
  }

  /// Converts a string to the corresponding DesktopImageFit enum value.
  static DesktopImageFit fromString(String str) => switch (str) {
        'contain' => contain,
        'cover' => cover,
        'fill' => fill,
        'fitWidth' => fitWidth,
        'fitHeight' => fitHeight,
        'none' => none,
        'scaleDown' => scaleDown,
        _ => throw SplashMasterException(
            message: 'Invalid desktop image fit: $str',
          ),
      };
}

/// All the available image position values for desktop splash configuration.
enum DesktopImagePosition {
  center,
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  /// Converts the enum value to the corresponding macOS X positioning constraints for the splash image.
  String get toMacosXPosition => switch (this) {
        left ||
        topLeft ||
        bottomLeft =>
          '      imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),',
        right ||
        topRight ||
        bottomRight =>
          '      imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),',
        _ =>
          '      imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),',
      };

  /// Converts the enum value to the corresponding macOS Y positioning constraints for the splash image.
  String get toMacosYPosition => switch (this) {
        top ||
        topLeft ||
        topRight =>
          '      imageView.topAnchor.constraint(equalTo: container.topAnchor),',
        bottom ||
        bottomLeft ||
        bottomRight =>
          '      imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),',
        _ =>
          '      imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),',
      };

  /// Returns true if the provided string is a valid [DesktopImagePosition] value.
  static bool isSupported(String? str) {
    if (str.isNullOrBlank) return false;
    return values.any((supported) => supported.name == str);
  }

  /// Converts a string to the corresponding DesktopImagePosition enum value.
  static DesktopImagePosition fromString(String str) => switch (str) {
        'center' => center,
        'top' => top,
        'bottom' => bottom,
        'left' => left,
        'right' => right,
        'topLeft' => topLeft,
        'topRight' => topRight,
        'bottomLeft' => bottomLeft,
        'bottomRight' => bottomRight,
        _ => throw SplashMasterException(
            message: 'Invalid desktop image position: $str',
          ),
      };
}

/// All the available branding image position values for desktop splash configuration.
enum DesktopBrandingPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight;

  // Converts the enum value to the corresponding macOS Auto Layout constraints
  // for the branding image, always relative to the splash container/window.
  String macosConstraints(int brandingSpacing) => switch (this) {
        topLeft => '''
        brandingView.topAnchor.constraint(equalTo: container.topAnchor, constant: $brandingSpacing),
        brandingView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: $brandingSpacing),''',
        topCenter => '''
        brandingView.topAnchor.constraint(equalTo: container.topAnchor, constant: $brandingSpacing),
        brandingView.centerXAnchor.constraint(equalTo: container.centerXAnchor),''',
        topRight => '''
        brandingView.topAnchor.constraint(equalTo: container.topAnchor, constant: $brandingSpacing),
        brandingView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -$brandingSpacing),''',
        centerLeft => '''
        brandingView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        brandingView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: $brandingSpacing),''',
        center => '''
        brandingView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        brandingView.centerYAnchor.constraint(equalTo: container.centerYAnchor),''',
        centerRight => '''
        brandingView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        brandingView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -$brandingSpacing),''',
        bottomLeft => '''
        brandingView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -$brandingSpacing),
        brandingView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: $brandingSpacing),''',
        bottomCenter => '''
        brandingView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -$brandingSpacing),
        brandingView.centerXAnchor.constraint(equalTo: container.centerXAnchor),''',
        bottomRight => '''
        brandingView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -$brandingSpacing),
        brandingView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -$brandingSpacing),''',
      };

  /// Returns true if the provided string is a valid [DesktopBrandingPosition] value.
  static bool isSupported(String? str) {
    if (str.isNullOrBlank) return false;
    return values.any((supported) => supported.name == str);
  }

  /// Converts a string to the corresponding DesktopBrandingPosition enum value.
  static DesktopBrandingPosition fromString(String str) => switch (str) {
        'topLeft' => topLeft,
        'topCenter' => topCenter,
        'topRight' => topRight,
        'centerLeft' => centerLeft,
        'center' => center,
        'centerRight' => centerRight,
        'bottomLeft' => bottomLeft,
        'bottomCenter' => bottomCenter,
        'bottomRight' => bottomRight,
        _ => throw SplashMasterException(
            message: 'Invalid desktop branding position: $str',
          ),
      };
}
