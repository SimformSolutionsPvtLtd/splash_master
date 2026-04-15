/*
 * Copyright (c) 2025 Simform Solutions
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

import 'package:rive/rive.dart';
import 'package:splash_master/splash_master.dart';

/// Provides a pre-loaded Rive [Artboard] instance as a splash source.
///
/// Use this when you have already loaded and initialized the artboard yourself
/// and want to pass it directly to [RiveSplash].
class RiveArtboardSource {
  const RiveArtboardSource(this.artboard);

  /// The pre-loaded Rive artboard instance to display.
  final Artboard artboard;
}

/// Type alias for the splash source accepted by [RiveSplash].
///
/// Either a [Source] (for asset / file / network / bytes loading) or a
/// [RiveArtboardSource] (for a pre-loaded artboard).
typedef RiveSource = Object;
