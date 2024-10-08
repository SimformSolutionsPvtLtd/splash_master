import 'package:flutter/material.dart';

typedef WarningCallback = void Function(String);
typedef OnVideoDuration = void Function(Duration);

class SplashMasterException implements Exception {
  final String message;

  SplashMasterException({required this.message});

  @override
  String toString() {
    return message;
  }
}

void skipFrame(VoidCallback fn) {
  WidgetsBinding.instance.addPostFrameCallback((_) => fn.call());
}
