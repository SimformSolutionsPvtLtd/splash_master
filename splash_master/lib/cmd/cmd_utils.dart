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

import 'dart:convert';

/// Command to create/setup the splash screen
enum Command {
  /// [create] used to create/setup the splash screen
  create,

  /// None
  none;

  static Command fromString(String str) => switch (str) {
        'create' => create,
        _ => none,
      };
}

/// Android drawable directory name
String getAndroidDrawable({
  bool android12 = false,
}) {
  const prefix = "drawable";
  final suffix = android12 ? '-v31' : '';
  return '$prefix-xxhdpi$suffix';
}

/// Scales are set according to latest [Apple guidelines](https://developer.apple.com/design/human-interface-guidelines/layout#Specifications)
/// on 21/10/2024 for iPhone.
enum IosScale {
  oneX(
    width: 320,
    height: 480,
    fileEndWith: '',
    scale: '1x',
  ),
  twoX(
    width: 828,
    height: 1792,
    fileEndWith: '@2x',
    scale: '2x',
  ),
  threeX(
    width: 1320,
    height: 2868,
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

const encoder = JsonEncoder.withIndent((' '));
