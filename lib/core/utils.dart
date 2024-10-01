import 'package:flutter/material.dart';

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

typedef WarningCallback = void Function(String);
