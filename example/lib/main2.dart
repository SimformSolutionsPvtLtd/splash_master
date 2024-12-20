import 'package:flutter/material.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_example/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMaster.initialize();

  /// You can initialize or setup any configuration at the start of the
  /// app until then native splash image will be visible to user.
  Future.delayed(const Duration(seconds: 3)).then(
    (value) {
      /// Once initialization completes call below method to resume your
      /// flutter app.
      SplashMaster.resume();
    },
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}
