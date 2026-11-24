# Splash Master: maintainer guide for coding agents

This repository holds four Flutter packages published separately to pub.dev.
These instructions are for working **on** the packages. Guidance for apps
that **use** them ships inside each package's `skills/` directory.

## Layout

| Directory | Package | Owns |
|---|---|---|
| `splash_master/` | `splash_master` | `dart run splash_master create` CLI (`bin/`, `lib/cmd/`), native Android/iOS splash generation, `pubspec.yaml` key definitions (`lib/values/yaml_keys.dart`), shared types (`Source` subclasses, `VisibilityEnum`) |
| `splash_master_rive/` | `splash_master_rive` | `SplashMasterRive`, `RiveConfig`, `RiveFileSource` (Rive 0.14 API) |
| `splash_master_video/` | `splash_master_video` | `SplashMasterVideo`, `VideoConfig` (video_player) |
| `splash_master_lottie/` | `splash_master_lottie` | `SplashMasterLottie`, `LottieConfig` (lottie) |
| `doc/documentation.md` | — | Combined documentation for all packages |

Each package has its own `README.md`, `CHANGELOG.md`, `doc/`, `example/`,
`preview/` and `skills/`.

## Where changes go

- Animation widgets and their renderer dependencies (`rive`, `video_player`,
  `lottie`) belong in the renderer package only. Never add them to
  `splash_master`.
- Anything shared by more than one renderer (source types, enums, exceptions)
  belongs in `splash_master` and is re-exported by each renderer's library
  file (`export 'package:splash_master/splash_master.dart';`).
- Renderer packages depend on the published `splash_master` (`^1.0.0`). Do not
  commit `path:` dependencies between packages; use a local, uncommitted
  `dependency_overrides` to test unpublished core changes.
- New `splash_master:` config keys must be added to `YamlKeys` and its
  `supportedYamlKeys` / `supportedAndroid12AndAboveYamlKeys` lists, or the CLI
  rejects them.

## Keep these in sync with any change

When a public API, config key, default or behavior changes, update in the
same PR:

1. The package's `README.md` and `doc/documentation.md`.
2. The root `doc/documentation.md`.
3. The package's `CHANGELOG.md` (format: `- Feature - …`, `- Fixed [#n](…) - …`,
   `- [Breaking] - …`).
4. The package's `example/`.
5. **The package's `skills/`** (see below). Skills ship to users with the
   package, so a stale skill makes their coding agents write broken code.

## Package skills (`skills/`)

Each package publishes agent skills following
[Dart package skills](https://dart.dev/tools/pub/package-skills). Users
install them with `dart run skills@ get`.

| Package | Skills |
|---|---|
| `splash_master` | `splash-master-native-splash`, `splash-master-migration` |
| `splash_master_rive` | `splash-master-rive-splash` |
| `splash_master_video` | `splash-master-video-splash` |
| `splash_master_lottie` | `splash-master-lottie-splash` |

Rules:

- One skill per user task, not per class. Add a new skill only for a new task
  (e.g. a future migration), otherwise extend the existing one.
- Directory name = frontmatter `name` = package name with `_` → `-`, then
  `-<topic>` (e.g. `splash-master-rive-splash`). Lowercase, digits and single
  hyphens only; the `skills` CLI silently skips names without the prefix.
- Frontmatter: `name` and `description` only. The description says what the
  skill does and when to use it (max 1024 characters).
- Keep `SKILL.md` under 500 lines. Move long tables to `references/` and link
  them with a relative path from the skill root.
- Write rules an agent can follow, and complete Dart examples that compile.
  State behavior that is verified in `lib/`, not what the docs claim.
- `skills/` must not be excluded by `.gitignore` or a `.pubignore`.

### Shared native-splash references (symlinks)

Users of a renderer package usually don't depend on `splash_master` directly,
and `dart run skills@ get` only installs skills from direct dependencies. So
each renderer skill ships the native-splash guidance itself, through
symlinks:

- The source of truth is
  `splash_master/skills/splash-master-native-splash/references/native-splash.md`
  and `config-keys.md`. Edit only these.
- `splash_master_{rive,video,lottie}/skills/*/references/native-splash.md` and
  `config-keys.md` are relative symlinks to them. `dart pub publish` packs the
  linked file's contents, so the published packages contain real files.
- Never symlink a whole skill directory: the `skills` CLI skips any skill
  whose name doesn't start with the package's own prefix.
- Shared reference files must not mention renderer-specific steps, and must
  refer to other files by skill-root paths (`references/config-keys.md`).
- On Windows, symlinks only check out when the repo is cloned with
  `git clone -c core.symlinks=true`; otherwise they become small text files.
  Before publishing, check in `dart pub publish --dry-run` that each
  `references/*.md` is a few KB, not a few bytes.

Validate with [`skills_lint`](https://pub.dev/packages/skills_lint). It needs
Dart SDK ^3.12, newer than these packages' minimum, so do **not** add it as a
dev dependency; install it globally instead:

```bash
dart pub global activate skills_lint
```

Run from each package directory:

```bash
dart pub global run skills_lint --ignore-config -d skills --check-relative-paths --check-relative-paths-within-skill=true --published-skill-name --published-skill-name-pubspec_path=pubspec.yaml --pub-archive-includes-skill --check-trailing-whitespace --disallowed-field
```

To test an install, create a throwaway Flutter app, add the package(s) with
`path:` dependencies, run `dart run skills@ get --all --agent claude`, and
check `.claude/skills/`. Only **direct** dependencies are scanned. Compile the
skill's Dart examples there with `flutter analyze`.

## Verifying changes

- There are no automated tests or CI in this repository yet. Run
  `flutter analyze` in every package and `example/` you touched.
- For CLI changes, run `dart run splash_master create` in
  `splash_master/example/` and in a fresh `flutter create` app, and read the
  output: the CLI logs errors but always exits with code 0.
- For widget changes, run the package's `example/` app on Android and iOS
  with a cold start.

## Pull requests

Follow `.github/pull_request_template.md`: a Conventional Commit title
(`feat:`, `fix:`, `docs:`; add `!` for breaking changes), the impacted
packages ticked, and migration instructions for breaking changes.
