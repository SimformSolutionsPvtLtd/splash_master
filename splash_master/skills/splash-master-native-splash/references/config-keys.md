# splash_master config keys

Every key goes under `splash_master:` in the app's `pubspec.yaml`. The CLI
rejects any key not listed here.

## Top-level keys

| Key | Platforms | Purpose | When omitted |
|---|---|---|---|
| `color` | Android, iOS | Background color (hex) | `#FFFFFF` (Android and iOS) |
| `image` | Android, iOS | Splash image | No image |
| `background_image` | Android, iOS | Full background image behind the splash image | No background layer |
| `color_dark` | Android, iOS | Dark mode background color | Light behavior is kept |
| `image_dark` | Android, iOS | Dark mode splash image (iOS also needs `image`) | Light image is kept |
| `background_image_dark` | Android, iOS | Dark mode background image (iOS also needs `background_image`) | Light background is kept |
| `ios_content_mode` | iOS | How `image` is laid out | `scaleToFill` |
| `ios_background_content_mode` | iOS | How `background_image` is laid out | `scaleToFill` (independent of `ios_content_mode`) |
| `android_gravity` | Android < 12 | Position of `image` | `fill` |
| `android_dark_gravity` | Android < 12 | Position of `image_dark` | Value of `android_gravity` |
| `android_background_image_gravity` | Android < 12 | Position of `background_image` and `background_image_dark` | `fill` |
| `android_12_and_above` | Android 12+ | Nested block, see below | Android 12+ uses the system defaults, unless an earlier run already generated `values-v31/styles.xml` (see "Removing keys" in `references/native-splash.md`) |

## Keys inside `android_12_and_above`

None of these fall back to top-level keys.

| Key | Purpose | When omitted |
|---|---|---|
| `color` | System splash background | None applied |
| `image` | System splash icon (replaces the app icon), 288×288 dp | App launcher icon |
| `color_dark` | Dark background | None applied |
| `image_dark` | Dark icon | `android_12_and_above.image` |
| `branding_image` | Image at the bottom, max 80 dp tall | No branding |
| `branding_image_dark` | Dark branding image | `android_12_and_above.branding_image` |

Gravity keys are ignored on Android 12+: the system splash API always centers
the icon.

## Allowed values

`ios_content_mode`, `ios_background_content_mode`:
`scaleToFill`, `scaleAspectFit`, `scaleAspectFill`, `redraw`, `center`, `top`,
`bottom`, `left`, `right`, `topLeft`, `topRight`, `bottomLeft`, `bottomRight`

`android_gravity`, `android_dark_gravity`, `android_background_image_gravity`:
`center`, `clip_horizontal`, `clip_vertical`, `fill_horizontal`, `fill`,
`center_vertical`, `bottom`, `fill_vertical`, `center_horizontal`, `top`,
`end`, `left`, `right`, `start`

Image files: `.png`, `.jpg`, `.jpeg`.
