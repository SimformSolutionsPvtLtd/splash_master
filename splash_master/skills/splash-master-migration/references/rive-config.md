# RiveConfig: 0.0.x (Rive 0.13) → 1.x (Rive 0.14)

`splash_master_rive` 1.x is built on Rive 0.14, which replaced the widget API.
Most old `RiveConfig` fields were removed. Rive types (`Fit`,
`ArtboardSelector`, `StateMachineSelector`, `RiveWidgetController`) come from
`package:rive/rive.dart`; add `rive` as a direct dependency
(`flutter pub add rive`) if the app references them.

| 0.0.x field | 1.x replacement |
|---|---|
| `artboardName: 'Main'` | `artboardSelector: ArtboardSelector.byName('Main')` |
| `stateMachineName: ['State Machine 1']` | `stateMachineSelector: StateMachineSelector.byName('State Machine 1')`. Only one state machine can be selected |
| `animations: [...]` | Removed. Rive 0.14 plays state machines only; ask the designer to add a state machine that plays the animation |
| `fit: BoxFit.contain` | `fit: Fit.contain` (Rive enum: `fill`, `contain`, `cover`, `fitWidth`, `fitHeight`, `none`, `scaleDown`, `layout`) |
| `alignment` | Unchanged |
| `onInit: (Artboard a) {...}` | `onInit: (RiveWidgetController c) {...}`; use `c.artboard`, `c.stateMachine` |
| `controllers: [...]` | Removed. Drive the state machine through `onInit`'s controller, or pass `controller:` (a Rive `Controller` factory) |
| `autoplay` | Removed. The selected state machine starts automatically |
| `behavior` | `hitTestBehavior` |
| `cursor`, `useSafeArea`, `placeHolder`, `splashDuration` | Unchanged |
| `assetLoader`, `loadCdnAssets`, `objectGenerator`, `clipRect`, `isTouchScrollEnabled`, `speedMultiplier`, `useArtboardSize`, `antialiasing`, `enablePointerEvents`, `headers` | Removed; delete them |
| — | New: `layoutScaleFactor` (for `Fit.layout`), `riveFactory`, `dataBind`, `controller` |

Defaults when omitted: default artboard, default state machine,
`Fit.contain`, `Alignment.center`.

Before:

```dart
SplashMaster.rive(
  source: AssetSource('assets/splash.riv'),
  riveConfig: RiveConfig(
    artboardName: 'Splash',
    stateMachineName: ['Intro'],
    fit: BoxFit.cover,
    splashDuration: const Duration(seconds: 2),
  ),
  nextScreen: const HomeScreen(),
)
```

After:

```dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' show ArtboardSelector, StateMachineSelector, Fit;
import 'package:splash_master_rive/splash_master_rive.dart';

// HomeScreen is the app's existing first screen.
Widget buildSplash() => SplashMasterRive(
      source: AssetSource('assets/splash.riv'),
      riveConfig: RiveConfig(
        artboardSelector: ArtboardSelector.byName('Splash'),
        stateMachineSelector: StateMachineSelector.byName('Intro'),
        fit: Fit.cover,
        splashDuration: const Duration(seconds: 2),
      ),
      nextScreen: const HomeScreen(),
    );
```

## Sources

Source support also changed: `DeviceFileSource` and `BytesSource` are not
supported by the Rive widget in 1.x. Use `AssetSource`, `NetworkFileSource`,
or `RiveFileSource` (a pre-loaded `rive.File`).

`RiveArtboardSource(artboard)` was removed. The widget now takes a file and
picks the artboard itself, so do not pass an `Artboard` anywhere:

- If the artboard came from a bundled `.riv` file, use
  `AssetSource('<that path>')` and move the artboard choice to
  `RiveConfig(artboardSelector: ArtboardSelector.byName('<name>'))`. Delete
  the code that loaded the file and the artboard.
- Only if the app must load the file itself (for example to reuse it
  elsewhere), pass the file, not the artboard:

```dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:splash_master_rive/splash_master_rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SplashMasterRive.initialize();
  final file = (await rive.File.asset(
    'assets/splash.riv',
    riveFactory: rive.Factory.rive,
  ))!;
  runApp(MaterialApp(
    home: SplashMasterRive(
      source: RiveFileSource(file),
      riveConfig: RiveConfig(
        artboardSelector: rive.ArtboardSelector.byName('Splash'),
      ),
      nextScreen: const HomeScreen(), // the app's existing first screen
    ),
  ));
}
```
