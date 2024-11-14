import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_master/splash_master.dart';
import 'package:splash_master_example/assets.dart';
import 'package:splash_master_example/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Uint8List imageData;
  imageData =
      (await rootBundle.load(Assets.sampleSplashScreen)).buffer.asUint8List();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        imageData: imageData,
      ),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.imageData,
  });

  final Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return SplashMaster.image(
      nextScreen: const Home(),
      splashDuration: const Duration(seconds: 1),
      source: BytesSource(imageData),
      imageConfig: const ImageConfig(fit: BoxFit.fill),
    );
  }
}
