typedef WarningCallback = void Function(String);
typedef OnSplashDuration = void Function(Duration);

class SplashMasterException implements Exception {
  final String message;

  SplashMasterException({required this.message});

  @override
  String toString() {
    return message;
  }
}
