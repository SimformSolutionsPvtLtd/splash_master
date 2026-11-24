# Native splash setup with splash_master

`splash_master` generates the native splash (shown before Flutter draws its
first frame) from a `splash_master:` block in the app's `pubspec.yaml`. The
`dart run splash_master create` CLI is available whenever `splash_master` is
in the app's dependencies, directly or through `splash_master_rive`,
`splash_master_video` or `splash_master_lottie`.

All keys, their platforms and fallbacks: `references/config-keys.md`.

## Steps

1. **Write the `splash_master:` block** as a top-level key in `pubspec.yaml`
   (sibling of `flutter:`, not nested under it). Include only the keys needed.
2. **Check every referenced image exists** on disk at the given path and is
   `.png`, `.jpg` or `.jpeg`.
3. **Run `dart run splash_master create`** from the app root.
4. **Read the CLI output.** The CLI exits with code 0 even when it fails, so
   never treat exit code 0 as success. Compare the output against
   "CLI messages" below and fix the config until no error lines remain.
5. **Tell the user** which native files changed and to do a full restart
   (not hot reload). The native splash only shows on a cold start.

## Rules

- All keys live under `splash_master:`. Unknown keys are rejected and the run
  is aborted; there are no aliases.
- Colors are hex strings in quotes: `'#FFFFFF'`.
- Image paths are relative to the app root: `'assets/splash.png'`. Native splash
  images do **not** need to be listed under `flutter: assets:`; the CLI copies
  them into the native projects.
- `branding_image` and `branding_image_dark` are valid **only** inside
  `android_12_and_above:`.
- `android_12_and_above:` is independent. Its keys never fall back to the
  top-level ones. If the app targets Android 12+ (all current apps do), set at
  least `android_12_and_above.color` and `android_12_and_above.image`, or
  Android 12+ devices show the app icon on the system default background.
- Android 12+ image: square icon, 288×288 dp artboard with the logo inside the
  inner circle (≈192 dp); anything outside is masked. Branding image: max 80 dp
  tall.
- Gravity keys (`android_gravity`, `android_dark_gravity`,
  `android_background_image_gravity`) affect Android **below 12** only.
- The CLI does **not** validate `android_dark_gravity`: an unsupported value
  is written into the dark splash drawable without an error and the Android
  build then fails. Check it against the allowed values in
  `references/config-keys.md` before running the CLI.
- Dark mode keys (`color_dark`, `image_dark`, `background_image_dark`) apply
  to both Android and iOS.
- iOS needs the light asset whenever a dark one is set: `image_dark` requires
  `image`, `background_image_dark` requires `background_image`. Otherwise iOS
  generation is skipped (Android still runs).
- iOS content modes use the full names: `scaleAspectFit`, `scaleAspectFill`
  (not `aspectFit` / `aspectFill`).
- Re-run `dart run splash_master create` after **every** change to the block.
  See "Removing keys" below: not every removed key is cleaned up.

## Removing keys

The CLI overwrites the files for the keys that are set, but it does not
always delete files for keys that were removed:

- **Removing `android_12_and_above`** leaves the files from the earlier run in
  place, so Android 12+ keeps the old splash. Delete the ones that exist by
  hand, then re-run the CLI:
  - `android/app/src/main/res/values-v31/styles.xml`
  - `android/app/src/main/res/values-night-v31/styles.xml`
  - in `android/app/src/main/res/drawable*/`: `splash_image_12.png`,
    `splash_image_12_dark.png`, `android_12_branding_image.png`,
    `android_12_branding_image_dark.png`

  Before deleting a `styles.xml`, check it holds only the splash style; if
  the app added its own items there, remove only the `windowSplashScreen*`
  items.
- **Removing all dark keys** (`color_dark`, `image_dark`,
  `background_image_dark`) while `android_12_and_above` is also absent deletes
  `values-night/styles.xml` and `values-night-v31/styles.xml`. With
  `android_12_and_above` present, the CLI instead points
  `values-night/styles.xml` back at the light drawable.

## Examples

Image on a color, light and dark, with Android 12+:

```yaml
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash/logo.png'
  color_dark: '#121212'
  image_dark: 'assets/splash/logo_dark.png'
  ios_content_mode: 'center'
  android_gravity: 'center'

  android_12_and_above:
    color: '#FFFFFF'
    image: 'assets/splash/logo_android12.png'
    color_dark: '#121212'
    image_dark: 'assets/splash/logo_android12_dark.png'
    branding_image: 'assets/splash/branding.png'
```

Full-screen background image with a centered logo:

```yaml
splash_master:
  background_image: 'assets/splash/background.png'
  image: 'assets/splash/logo.png'
  ios_background_content_mode: 'scaleAspectFill'
  ios_content_mode: 'center'
  android_background_image_gravity: 'fill'
  android_gravity: 'center'
```

Color only:

```yaml
splash_master:
  color: '#0A84FF'
  android_12_and_above:
    color: '#0A84FF'
```

## CLI messages

| Output | Cause | Fix |
|---|---|---|
| `Unable to read yaml file.` | No `splash_master:` block, or it is not a map | Add the block at the top level of `pubspec.yaml` |
| `Unsupported key(s) in splash_master: …` | Unknown or legacy key (e.g. `image_dark_android`) | Use the supported key names listed in the message |
| `Unsupported key(s) in android_12_and_above: …` | Wrong nested key | Allowed: `image`, `color`, `image_dark`, `color_dark`, `branding_image`, `branding_image_dark` |
| `Please check the android_12_and_above configuration…` | `android_12_and_above` is not a nested map | Indent its keys under it |
| `Invalid android gravity.` | `android_gravity` or `android_background_image_gravity` is not in the allowed list (the message does not say which) | Check both against `references/config-keys.md` |
| `Please check the ios_content_mode` / `Please check the ios_background_content_mode` | Value not in the allowed list | Use a value from `references/config-keys.md` |
| `Asset not found. <path>` | A top-level image path does not exist | Fix the path relative to the app root |
| `Image path not found` | `android_12_and_above.image` does not exist | Fix that path |
| `Branding Image path not found` | `android_12_and_above.branding_image` does not exist | Fix that path |
| `Android 12+ dark image path not found: <path>.` | `android_12_and_above.image_dark` does not exist | Fix that path |
| `Dark branding image path not found: <path>.` | `android_12_and_above.branding_image_dark` does not exist | Fix that path |
| `<key> should point to a png, jpg, or jpeg asset.` | Unsupported image format | Convert the image |
| `Skipping iOS splash generation: …` | Dark asset without its light counterpart | Add `image` / `background_image` |

## What the CLI changes

- Android: `android/app/src/main/res/drawable*/` (splash images,
  `splash_screen.xml`), `values/`, `values-night/`, `values-v31/`,
  `values-night-v31/` (`styles.xml`, `colors.xml`).
- iOS: `ios/Runner/Assets.xcassets/LaunchImage.imageset`,
  `BackgroundImage.imageset`, and `ios/Runner/Base.lproj/LaunchScreen.storyboard`.

These are generated files. Edit the `splash_master:` block and re-run the CLI
instead of hand-editing them.
