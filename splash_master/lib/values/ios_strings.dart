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

/// IOS Strings Element, attribute keys and values
class IOSStrings {
  IOSStrings._();

  /// Folder name
  static const ios = 'ios';

  /// `splash_image`
  static const splashImage = 'splash_image';

  /// `universal`
  static const iOSContentJsonIdiom = 'universal';

  /// `Contents.json`
  static const iosContentJson = 'Contents.json';

  /// Element string
  ///
  /// `document`
  static const documentElement = 'document';

  /// `view`
  static const viewElement = 'view';

  /// `subviews`
  static const subViewsElement = 'subviews';

  /// `color`
  static const colorElement = 'color';

  /// `constraints`
  static const constraintsElement = 'constraints';

  /// `resources`
  static const resourcesElement = 'resources';

  /// `image` storyboard resource element
  static const imageResourceElement = 'image';

  /// Element ID
  /// `Ze5-6b-2t3`
  static const defaultViewId = 'Ze5-6b-2t3';

  /// Attribute and value string for color
  ///
  /// `id`
  static const viewIdAttr = 'id';

  /// `#FFFFFF`
  static const defaultColor = '#FFFFFF';

  /// `key`
  static const colorKeyAttr = 'key';

  /// `name`
  static const nameAttr = 'name';

  /// `backgroundColor`
  static const colorKeyAttrVal = 'backgroundColor';

  /// `customColorSpace`
  static const customColorAttr = 'customColorSpace';

  /// `sRGB`
  static const customColorAttrVal = 'sRGB';

  /// `red`
  static const redColorAttr = 'red';

  /// `green`
  static const greenColorAttr = 'green';

  /// `blue`
  static const blueColorAttr = 'blue';

  /// `alpha`
  static const colorAlphaAttr = 'alpha';

  /// `1`
  static const defaultAlphaAttrVal = '1';

  /// ImageView Element and attribute
  ///
  /// `imageView`
  static const imageViewElement = 'imageView';

  /// Attribute
  ///
  /// `opaque`
  static const opaque = 'opaque';

  /// `clipsSubviews`
  static const clipsSubviews = 'clipsSubviews';

  /// `multipleTouchEnabled`
  static const multipleTouchEnabled = 'multipleTouchEnabled';

  /// `contentMode`
  static const contentMode = 'contentMode';

  /// `image`
  static const image = 'image';

  /// `translatesAutoresizingMaskIntoConstraints`
  static const translatesAutoresizingMaskIntoConstraints =
      'translatesAutoresizingMaskIntoConstraints';

  /// `id`
  static const defaultImageViewId = 'id';

  /// `NO`
  static const opaqueValue = 'NO';

  /// `YES`
  static const clipsSubviewsValue = 'YES';

  /// `YES`
  static const multipleTouchEnabledValue = 'YES';

  /// `scaleToFill`
  static const contentModeValue = 'scaleToFill';

  /// `LaunchImage`
  static const imageValue = 'LaunchImage';

  /// `NO`
  static const translatesAutoresizingMaskIntoConstraintsVal = 'NO';

  /// `YRO-k0-Ey4`
  static const defaultImageViewIdValue = 'YRO-k0-Ey4';

  /// `edQ-YT-iED`
  static const backgroundImageViewIdValue = 'edQ-YT-iED';

  /// Rect Element
  ///
  /// `rect`
  static const rectElement = 'rect';

  /// Attributes of rect element
  ///
  /// `key`
  static const rectElementKeyAttr = 'key';

  /// `x`
  static const rectElementXAttr = 'x';

  /// `y`
  static const rectElementYAttr = 'y';

  /// `width`
  static const rectElementWidthAttr = 'width';

  /// `height`
  static const rectElementHeightAttr = 'height';

  /// `frame`
  static const rectElementKeyAttrValue = 'frame';

  /// `0.0`
  static const rectElementXAttrVal = '0.0';

  /// `0.0`
  static const rectElementYAttrVal = '0.0';

  /// `393`
  static const rectElementWidthAttrVal = '393';

  /// `1280`
  static const rectElementHeightAttrVal = '1280';

  /// Default storyboard image resource width metadata.
  ///
  /// This is metadata for LaunchScreen.storyboard resources and not a layout size.
  static const storyboardImageResourceWidth = '720';

  /// Default storyboard image resource height metadata.
  ///
  /// This is metadata for LaunchScreen.storyboard resources and not a layout size.
  static const storyboardImageResourceHeight = '1280';

  /// `BackgroundImage`
  static const backgroundImage = 'BackgroundImage';

  /// `background_image`
  static const backgroundImageSnakeCase = 'background_image';

  /// `splash_image_dark`
  static const splashImageDark = 'splash_image_dark';

  /// `background_image_dark`
  static const backgroundImageDarkSnakeCase = 'background_image_dark';

  /// Appearance key used in Contents.json for dark mode
  static const appearanceKey = 'appearance';

  /// Appearance attribute value: `luminosity`
  static const appearanceLuminosity = 'luminosity';

  /// Appearance value attribute key
  static const appearanceValueKey = 'value';

  /// Appearance value for dark mode: `dark`
  static const appearanceDark = 'dark';

  /// `LaunchBackgroundColor`
  static const launchBackgroundColorAssetName = 'LaunchBackgroundColor';

  /// `LaunchBackgroundColor.colorset`
  static const launchBackgroundColorSetDirectory =
      'LaunchBackgroundColor.colorset';
}
