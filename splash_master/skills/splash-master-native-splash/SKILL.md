---
name: splash-master-native-splash
description: >-
  Configure and generate the native Android/iOS splash screen with splash_master:
  the `splash_master:` block in pubspec.yaml (color, image, background image,
  dark mode, Android 12+ icon and branding, gravity/content mode) and the
  `dart run splash_master create` CLI. Use when adding, changing or debugging a
  native splash screen, or when the CLI reports an error.
---

# splash_master: native splash screen

`splash_master` generates the native splash (shown before Flutter draws its
first frame) from a `splash_master:` block in the app's `pubspec.yaml`. An
image/color splash needs **no Dart code**. Animated splashes (Rive, video,
Lottie) are separate packages that run *after* this native splash.

## Workflow

1. **Inspect the project first.** Read `pubspec.yaml`. Check whether
   `splash_master` (or a `splash_master_*` package) is already a dependency and
   whether a `splash_master:` block exists. Look for existing splash assets
   (`assets/`, `images/`). Only ask the user for what cannot be found: the
   colors and which image files to use.
2. **Add the dependency** if no `splash_master*` package is present:
   `flutter pub add splash_master`. Never hard-code a version.
3. **Read `references/native-splash.md`** and follow its steps: write the
   block, check the images, run `dart run splash_master create`, and read the
   CLI output (it exits with code 0 even on errors). It also holds the rules,
   examples and the meaning of every CLI message.
4. Use `references/config-keys.md` for every key, its platform, fallback and
   allowed values.

## Animated splash after the native one

For a Rive, video or Lottie splash, keep this native splash (it covers app
start-up) and add the matching package: `splash_master_rive`,
`splash_master_video` or `splash_master_lottie`. Each ships its own skill;
run `dart run skills@ get` after adding it.
