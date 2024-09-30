import 'dart:io';

import 'package:flutter/services.dart';
import 'package:splash_master/core/utils.dart';

abstract class Source {
  void setSource();
}

class AssetSource extends Source {
  AssetSource(this.path) {
    setSource();
  }

  final String path;

  @override
  Future<void> setSource() async {}
}

class DeviceFileSource extends Source {
  DeviceFileSource(this.path) {
    setSource();
  }

  final String path;

  late final File file;

  @override
  Future<void> setSource() async {
    file = File(path);
  }
}

class NetworkFileSource extends Source {
  NetworkFileSource(this.path);

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

class BytesSource extends Source {
  BytesSource(this.bytes);

  final Uint8List bytes;

  @override
  void setSource() {}
}
