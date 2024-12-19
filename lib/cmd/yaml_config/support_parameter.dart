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

import 'package:splash_master/core/utils.dart';

/// Supported image extensions
enum SupportedImageExtensions {
  jpg,
  png,
  jpeg;

  static SupportedImageExtensions fromString(String str) {
    switch (str) {
      case 'jpg':
        return jpg;
      case 'png':
        return png;
      case 'jpeg':
        return jpeg;
      default:
        throw SplashMasterException(
          message: 'The image must be jpg, png or jpeg.',
        );
    }
  }
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

  static AndroidGravity fromString(String str) {
    switch (str) {
      case 'center':
        return center;
      case 'clip_horizontal':
        return clipHorizontal;
      case 'clip_vertical':
        return clipVertical;
      case 'fill_horizontal':
        return fillHorizontal;
      case 'fill':
        return fill;
      case 'center_vertical':
        return centerVertical;
      case 'bottom':
        return bottom;
      case 'fill_vertical':
        return fillVertical;
      case 'center_horizontal':
        return centerHorizontal;
      case 'top':
        return top;
      case 'end':
        return end;
      case 'left':
        return left;
      case 'right':
        return right;
      case 'start':
        return start;
      default:
        throw SplashMasterException(message: 'Invalid android gravity.');
    }
  }
}

/// All the available iOS content mode values
enum IosContentMode {
  scaleToFill('scaleToFill'),
  scaleAspectFit('scaleAspectFit'),
  scaleAspectFill('scaleAspectFill'),
  redraw('redraw'),
  center('center'),
  top('top'),
  bottom('bottom'),
  left('left'),
  right('right'),
  topLeft('topLeft'),
  topRight('topRight'),
  bottomLeft('bottomLeft'),
  bottomRight('bottomRight');

  final String mode;

  const IosContentMode(this.mode);

  static IosContentMode fromString(String str) {
    switch (str) {
      case 'scaleToFill':
        return scaleToFill;
      case 'aspectFit':
        return scaleAspectFit;
      case 'aspectFill':
        return scaleAspectFill;
      case 'redraw':
        return redraw;
      case 'center':
        return center;
      case 'top':
        return top;
      case 'bottom':
        return bottom;
      case 'left':
        return left;
      case 'right':
        return right;
      case 'topLeft':
        return topLeft;
      case 'topRight':
        return topRight;
      case 'bottomLeft':
        return bottomLeft;
      case 'bottomRight':
        return bottomRight;
      default:
        throw SplashMasterException(message: 'Invalid content mode.');
    }
  }
}
