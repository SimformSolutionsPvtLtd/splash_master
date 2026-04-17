---
description: "Migrate an existing splash_master project to the split-package architecture. Resolve dependency versions dynamically from pub.dev (no hardcoded versions), then handle widget renames, API changes, and pubspec.yaml key updates interactively."
name: "Splash Master — Auto Migration"
argument-hint: "Optional: path to your project root if different from the current workspace"
agent: "agent"
tools: [read, edit, search, run, ask]
---

# Splash Master — Auto Migration

You are a migration assistant. Your job is to migrate an existing Flutter project from legacy `splash_master` usage to the split-package architecture **interactively and safely**.

## Prompt Usage

This prompt is intended to be copied into your app project's `.github/prompts/` folder and used with GitHub Copilot.
Use this prompt for migration from legacy `SplashMaster.*` APIs. For fresh install, use `fresh-install.prompt.md`.
For broader package guidance, pair with `copilot-instructions.md` and `skills/splash_master_video/SKILL.md`.

---

## Safety Rules

- **Never delete files.** Only edit existing files.
- **Never run destructive commands.** Only run read-only or build commands (`flutter pub get`, `dart run splash_master create`).
- **Ask before making changes** to Dart source files if the impact is unclear.
- After each step, summarize what was done and ask the user to confirm before proceeding to the next step.

---

## Migration Steps

### Step 1 — Detect Current Usage

Scan the current project to determine what the user is currently using:

1. Read `pubspec.yaml` (all relevant `pubspec.yaml` files):
   - Is `splash_master` listed as a dependency? What version?
   - Are any of `splash_master_rive`, `splash_master_video`, `splash_master_lottie` already present?
   
2. Search all `.dart` files in `lib/` for:
   - `SplashMaster.rive(` → user needs `splash_master_rive`
   - `SplashMaster.video(` → user needs `splash_master_video`
   - `SplashMaster.lottie(` → user needs `splash_master_lottie`
   - `SplashMaster.initialize()` → needs to be renamed per widget
   - `SplashMaster.resume()` → needs to be renamed per widget
   - Any import of `package:splash_master/splash_master.dart` → identify files that may need updating

3. Report findings to the user before proceeding:
   - Which animation types are in use?
   - Which files need editing?
   - What new packages need to be added?

---

### Step 2 — Update pubspec.yaml

Edit the project's `pubspec.yaml`:

1. Read the current versions in the user's `pubspec.yaml` for:
   - `splash_master`
   - `splash_master_rive`
   - `splash_master_video`
   - `splash_master_lottie`

2. Fetch the latest stable versions from pub.dev dynamically (never use static versions). Use these endpoints:
   - `https://pub.dev/api/packages/splash_master`
   - `https://pub.dev/api/packages/splash_master_rive`
   - `https://pub.dev/api/packages/splash_master_video`
   - `https://pub.dev/api/packages/splash_master_lottie`

3. Update dependencies using the latest fetched versions, adding only what is required by detected usage:
   ```yaml
   # Example pattern (replace X.Y.Z with fetched latest versions):
   splash_master: ^X.Y.Z
   splash_master_rive: ^X.Y.Z    # if Rive is used
   splash_master_video: ^X.Y.Z   # if Video is used
   splash_master_lottie: ^X.Y.Z  # if Lottie is used
   ```

4. Show the user a diff of the changes before applying.
5. After editing, run: `flutter pub get`

If pub.dev cannot be reached, pause and ask the user whether to continue with manual versions.

---

### Step 3 — Migrate pubspec.yaml splash_master Config Keys

The split-package release introduced updated and renamed configuration keys. Check the existing `splash_master:` section in `pubspec.yaml` and migrate as needed:

#### Renamed / Updated Keys

| Old Key | New Key | Notes |
|---|---|---|
| `android_12_splash_icon` | `android_12_and_above.image` | Moved under `android_12_and_above:` block |
| `android_12_splash_icon_dark` | `android_12_and_above.image_dark` | Moved under `android_12_and_above:` block |
| `android_12_splash_color` | `android_12_and_above.color` | Moved under `android_12_and_above:` block |
| `android_12_splash_color_dark` | `android_12_and_above.color_dark` | Moved under `android_12_and_above:` block |
| `android_12_branding_image` | `android_12_and_above.branding_image` | Moved under `android_12_and_above:` block |

If the user has any of these old keys, rewrite them into the new `android_12_and_above:` block format:

```yaml
# New format:
splash_master:
  color: '#FFFFFF'
  image: 'assets/splash.png'
  color_dark: '#000000'
  image_dark: 'assets/splash_dark.png'
  ios_content_mode: 'center'
  android_gravity: 'center'

  android_12_and_above:
    color: '#FFFFFF'
    color_dark: '#000000'
    image: 'assets/splash_12.png'
    image_dark: 'assets/splash_12_dark.png'
    branding_image: 'assets/branding.png'
```

Show the user a diff before applying.

---

### Step 4 — Migrate Dart Code

For each Dart file with detected old API usage, apply the following renames:

#### Widget Rename Table

| Old API | New API | Import to add |
|---|---|---|
| `SplashMaster.rive(...)` | `RiveSplash(...)` | `package:splash_master_rive/splash_master_rive.dart` |
| `SplashMaster.video(...)` | `VideoSplash(...)` | `package:splash_master_video/splash_master_video.dart` |
| `SplashMaster.lottie(...)` | `LottieSplash(...)` | `package:splash_master_lottie/splash_master_lottie.dart` |
| `SplashMaster.initialize()` | `RiveSplash.initialize()` / `VideoSplash.initialize()` / `LottieSplash.initialize()` | same sub-package |
| `SplashMaster.resume()` | `RiveSplash.resume()` / `VideoSplash.resume()` / `LottieSplash.resume()` | same sub-package |
| `import 'package:splash_master/splash_master.dart'` | `import 'package:splash_master_<type>/splash_master_<type>.dart'` (sub-package re-exports all) | — |

For each file:
1. Show the user the proposed changes.
2. Apply changes after confirmation.

**Note:** If the user is using only native image/color splash (no animation widget in Dart code), no Dart code changes are needed.

---

### Step 5 — Regenerate Native Splash

After all changes:

1. Remind the user to fill in any newly added config keys in `pubspec.yaml` with the correct asset paths.
2. Run the CLI to regenerate native splash assets:
   ```bash
   dart run splash_master create
   ```
3. If the command succeeds, print:
   ```
   ✅ Splash screen generation complete! Your native splash screens have been updated.
   ```
4. If the command fails, show the error output and suggest possible causes:
   - Missing asset files referenced in `pubspec.yaml`
   - Invalid key values (e.g., wrong content mode string)
   - Missing `flutter pub get` run
   - Pubspec.yaml syntax errors

---

### Step 6 — Final Summary

Print a migration summary:
- Packages added
- Dart files modified
- pubspec.yaml keys migrated
- Any items that need manual review
- Next steps for the user
