# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Mishwarak (مشوارك)** is a ride-hailing app for Yemen. The repo contains two parallel workstreams:

1. **Design prototype** (root level) — browser-rendered React/JSX prototype using Babel Standalone; no build step.
2. **Flutter app** (`flutter_code/`) — the production mobile implementation.

---

## Design Prototype (Root)

Open `Mishwarak.html` directly in a browser to view the prototype. No build, no server.

**Key files:**
- `design-system.js` — single source of truth for all design tokens (colors, spacing, radii, typography, bilingual helper `T(ar, en, lang)`). Exports to `window`.
- `app.jsx` / `design_canvas.jsx` / `tweaks_panel.jsx` — live-editing canvas and tweak controls.
- `screens-{onboarding,home,ride,menu}.jsx` — screen components.
- `icons.jsx`, `avatars.jsx`, `map-component.jsx`, `android_frame.jsx`, `ios_frame.jsx` — shared UI components.

**Design system has two parallel versions:**
- **Version A** (active default): Classic Refined, Careem-inspired — primary green `#00A651`.
- **Version B**: Bold Modern, Uber-inspired — primary orange `#FF6B35`.

Use `getTheme('A'|'B', 'light'|'dark')` to access a version's palette.

---

## Flutter App (`flutter_code/`)

### Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Lint
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Regenerate Freezed / JSON serialization code (run after editing any .dart model with @freezed or @JsonSerializable)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Architecture

**Feature-first folder structure:**
```
lib/
  core/
    providers/     # locale_provider, theme_provider (Riverpod StateNotifiers)
    router/        # app_router.dart — all routes declared here via go_router
    theme/         # app_colors.dart (MishwarakColors), app_theme.dart (AppTheme.light/dark)
  features/
    auth/          # login_screen, otp_screen
    booking/       # vehicle_selection, finding_driver + models/
    home/          # home_screen + widgets/home_drawer
    onboarding/
    ride/          # active_ride, rating + models/
    splash/
    search/
    wallet/
    history/
    profile/
    notifications/
  shared/
    widgets/       # glass_button, placeholder_screen, saved_place_card, service_shortcut
  main.dart
```

**State management:** Riverpod — wrap state reads in `ConsumerWidget` / `ConsumerStatefulWidget`, use `ref.watch` / `ref.read`.

**Navigation:** `go_router` via `appRouterProvider`. All route paths are declared as constants in `AppRoutes` (`lib/core/router/app_router.dart`). Sub-routes of `/home` use relative paths (e.g., `home/search`). Pass query params via `state.uri.queryParameters` (see `OtpScreen`).

**Data models:** `freezed` + `json_annotation`. Each model has three files — `model.dart`, `model.freezed.dart`, `model.g.dart`. Always run `build_runner` after changing a `@freezed` class.

**Theme & colors:** `MishwarakColors` (static constants) → consumed by `AppTheme.light` and `AppTheme.dark` (Material 3). Theme mode toggled via `themeModeProvider`. Font is **IBM Plex Sans Arabic** (loaded via `google_fonts`; local font assets not yet added).

**Localization:** Default locale `ar_YE` (RTL). Switch via `LocaleNotifier.toggle()` or `setLocale('en'|'ar')`, persisted to `SharedPreferences`. No ARB/gen-l10n files yet — bilingual strings are currently inlined as `nameAr`/`nameEn` pairs on models.

**Currency:** Yemeni Rial (YER); prices stored as `int` on `VehicleType`.

### Currently Disabled / Placeholder

| Feature | Reason | Re-enable path |
|---|---|---|
| Google Maps (`google_maps_flutter`) | Needs API key; no Windows desktop support | Add key to `web/index.html` + Android/iOS, uncomment in `pubspec.yaml` |
| Firebase | No `firebase_options.dart` | Run `flutterfire configure`, add `firebase_core` |
| `retrofit` / `retrofit_generator` | Incompatible with current Dart SDK | Re-check when SDK updates |

The map area on `HomeScreen` is a plain `Container` placeholder — replace with `GoogleMap` widget once the API key is configured.
