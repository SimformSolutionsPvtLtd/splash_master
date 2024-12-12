import 'package:splash_master/core/utils.dart';

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

enum IosContentMode {
  scaleToFill,
  aspectFit,
  aspectFill,
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

  static IosContentMode fromString(String str) {
    switch (str) {
      case 'scaleToFill':
        return scaleToFill;
      case 'aspectFit':
        return aspectFit;
      case 'aspectFill':
        return aspectFill;
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
