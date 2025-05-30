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

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:splash_master/core/utils.dart';

/// Holds the source file
sealed class Source {
  void setSource();
}

final class AssetSource extends Source {
  /// Provides the asset resource for the splash screen
  AssetSource(this.path);

  final String path;

  @override
  Future<void> setSource() async {}
}

final class DeviceFileSource extends Source {
  /// Provides the device file for the splash screen
  DeviceFileSource(this.path);

  final String path;

  late final File file;

  @override
  Future<void> setSource() async {
    file = File(path);
  }
}

final class NetworkFileSource extends Source {
  /// Provides the network source for the splash screen
  NetworkFileSource(this.path) {
    setSource();
  }

  final String path;

  Uri? _url;

  Uri? get url => _url;

  @override
  void setSource() {
    _url = Uri.tryParse(path);
    if (_url == null) {
      throw SplashMasterException(message: 'Unable to parse uri.');
    }
  }
}

final class BytesSource extends Source {
  /// Provides the source as bytes for the splash screen
  BytesSource(this.bytes);

  final Uint8List bytes;

  @override
  void setSource() {}
}

/// Provides a pre-loaded Rive artboard instance for the splash screen
final class RiveArtboardSource extends Source {
  /// Provides a pre-loaded Rive artboard instance for the splash screen
  RiveArtboardSource(this.artboard);

  /// The Rive artboard instance to display
  final Artboard artboard;

  @override
  void setSource() {}
}
