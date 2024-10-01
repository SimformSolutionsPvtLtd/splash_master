import 'package:flutter/material.dart';

enum SplashMediaType { image, video, lottie, rive, custom }

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
