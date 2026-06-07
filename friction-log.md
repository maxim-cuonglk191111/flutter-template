# Friction Log

## 2026-05-29 — Flutter Core Template

- **Flutter SDK not in system PATH**: `flutter` command not recognized on this Windows machine; Flutter SDK is not installed — had to write all project files manually without `flutter create`, requiring the user to run `flutter pub get` once they have the SDK set up.

## 2026-05-29 — v1.1 Upgrade

- **prd_11.md was empty on first read**: The file content arrived via the diff/context metadata, not from a direct file read — always read PRD from both the file and the diff context when a new version is introduced.
- **`easy_localization` named args**: The `tr(namedArgs: {...})` API uses `namedArgs` (Map), NOT positional args — `{count}` placeholder in JSON, `.tr(namedArgs: {'count': '$val'})` in Dart.
- **`in_app_update` requires real Play Store**: `InAppUpdate.checkForUpdate()` will throw in debug/local builds not distributed via Play Store — always wrap in try/catch and fail silently.

## 2026-06-07 — Flutter Fixes

- **`purchases_flutter` v8 Breaking Changes**: The `Purchases.purchasePackage` method returns a `PurchaseResult` struct instead of `CustomerInfo`, meaning entitlements must be accessed via `result.customerInfo.entitlements`.
- **Flutter 3.44 Theme Normalization**: `CardTheme` and `DialogTheme` properties inside `ThemeData` now explicitly require `CardThemeData` and `DialogThemeData` respectively instead of the root widget classes.
