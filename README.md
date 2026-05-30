# Flutter Core Template 🚀 `v1.1`

> **App Factory Boilerplate** — Clone once, reskin in 2–5 days, ship a new Android app.

---

## What's Included

| Module | Status | Description |
|--------|--------|-------------|
| 🔐 Auth | ✅ | Firebase Auth — Google Sign-In + Anonymous |
| 💳 Paywall | ✅ | RevenueCat — subscription modal, entitlement check |
| 📺 Ads | ✅ | AdMob — Banner, Rewarded, Interstitial |
| 📊 Analytics | ✅ | Firebase Analytics + Crashlytics |
| 🎠 Onboarding | ✅ | 3-slide carousel + CTA |
| ⚙️ Settings | ✅ | Dark mode, language picker, privacy policy, restore purchase |
| 🎨 Theme | ✅ | Material 3, single-file color token |
| 🔔 Notifications | ✅ | Firebase Cloud Messaging |
| 📐 Responsive | ✅ v1.1 | flutter_screenutil — `.sp/.w/.h/.r` everywhere |
| 🌍 i18n | ✅ v1.1 | easy_localization — EN + VI, runtime switch |
| 💀 Skeleton UI | ✅ v1.1 | skeletonizer — loading states on any widget |
| 🔒 Secure Storage | ✅ v1.1 | flutter_secure_storage — tokens in Keystore |
| 🔑 Env Vars | ✅ v1.1 | flutter_dotenv — `.env` local, CI/CD prod |
| 🔄 In-App Update | ✅ v1.1 | in_app_update — Play Store flexible update |
| ⚙️ Remote Config | ✅ v1.1 | Firebase Remote Config — limits/flags OTA |
| 🤖 AI Chat | 🔜 v1.2 | OpenAI / Gemini chat module |

---

## 🏎️ Spawn a New App — Step by Step

### Step 1: Clone & Rename

```bash
git clone https://github.com/you/flutter-template.git my-new-app
cd my-new-app
```

### Step 2: Edit `lib/config/app_config.dart`

This is the **only file you must change** for basic branding:

```dart
static const String appName = 'My New App';          // ← change
static const String packageName = 'com.me.myapp';    // ← change
static const int primarySeed = 0xFF6C63FF;           // ← change color
static const int freeAiMessagesPerDay = 5;           // ← adjust limit
```

### Step 3: Change Package Name

Update these files with your new package name (`com.me.myapp`):
- `android/app/build.gradle` → `applicationId`
- `android/app/src/main/kotlin/` → rename folder structure
- `android/app/src/main/AndroidManifest.xml` → `namespace`
- `android/settings.gradle` → already uses `namespace`

**Tip:** Use Android Studio's refactor → rename package to do this automatically.

### Step 4: Set Up Firebase

1. Go to [Firebase Console](https://console.firebase.google.com) → Create new project
2. Add Android app with your package name
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`
5. Enable: **Auth** (Google + Anonymous), **Analytics**, **Crashlytics**, **Cloud Messaging**

> ⚠️ `google-services.json` is in `.gitignore` — never commit it.

### Step 5: Set Up RevenueCat

1. Create app in [RevenueCat Dashboard](https://app.revenuecat.com)
2. Copy your Android API key
3. Run with:
   ```bash
   flutter run --dart-define=REVENUECAT_API_KEY=your_key_here
   ```
4. Or set `AppConfig.revenueCatApiKey` directly (don't commit to public repos)
5. Create entitlement named **`premium`** in RevenueCat dashboard

### Step 6: Set Up AdMob

1. Create app in [AdMob Console](https://admob.google.com)
2. Replace App ID in `AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXX~YYYY" />
   ```
3. Create ad units (Banner, Rewarded, Interstitial)
4. Pass IDs via `--dart-define` or update `AppConfig`:
   ```bash
   flutter run \
     --dart-define=ADMOB_BANNER_ID=ca-app-pub-xxx/yyy \
     --dart-define=ADMOB_REWARDED_ID=ca-app-pub-xxx/zzz
   ```

### Step 7: Replace App Icon

1. Put your 1024×1024 PNG at `assets/icons/app_icon.png`
2. Run:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

### Step 8: Customize Onboarding Slides

Edit `lib/core/onboarding/onboarding_screen.dart` → `_slides` list:

```dart
static const List<_SlideData> _slides = [
  _SlideData(
    title: 'Your App Title',
    subtitle: 'Your value proposition',
    icon: Icons.your_icon,
    iconColor: Color(0xFFyourcolor),
    bgColor: Color(0xFFyourcolor),
  ),
  // ...
];
```

### Step 9: Build & Test

```bash
flutter pub get
flutter analyze
flutter run

# Release build
flutter build apk --release
```

### Step 10: Deploy

```bash
# Internal testing via Firebase App Distribution
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_FIREBASE_APP_ID \
  --groups "internal-testers"

# Or upload to Play Store → Internal Testing → Production
```

---

## Development Commands

```bash
# Run in debug mode (with test ad IDs)
flutter run

# Run with real keys
flutter run \
  --dart-define=REVENUECAT_API_KEY=xxx \
  --dart-define=ADMOB_BANNER_ID=xxx \
  --dart-define=ADMOB_REWARDED_ID=xxx

# Analyze code
flutter analyze

# Run tests
flutter test

# Generate code (Riverpod, Hive)
dart run build_runner build --delete-conflicting-outputs

# Build release APK
flutter build apk --release

# Build release AAB (for Play Store)
flutter build appbundle --release
```

---

## Project Structure

```
lib/
├── config/
│   └── app_config.dart           ← 🎯 CHANGE ONLY THIS FILE
├── core/
│   ├── analytics/                ← Firebase Analytics wrapper
│   ├── auth/                     ← Google + Anonymous auth
│   ├── paywall/                  ← RevenueCat integration
│   ├── ads/                      ← AdMob (banner, rewarded, interstitial)
│   ├── onboarding/               ← 3-slide carousel
│   ├── settings/                 ← Dark mode, legal, restore
│   └── notifications/            ← Firebase Messaging
├── shared_ui/
│   └── theme/                    ← AppTheme, AppColors, AppTypography
├── features/
│   ├── dashboard/                ← Home screen shell
│   └── splash/                   ← Splash screen
├── router/
│   └── app_router.dart           ← go_router with auth redirect
├── app.dart                      ← Root widget
└── main.dart                     ← Entry point
```

---

## Free Limit Flow

```
User taps action
    ↓
isPremium? → YES → allow action
    ↓ NO
FreeLimitNotifier.consume('feature', limit: 5)
    ↓
Under limit? → YES → allow action + increment counter
    ↓ NO
logFreeLimitHit() + show PaywallModal
    ↓
User subscribes → RevenueCat → isPremium = true
User dismisses → show RewardedAd for bonus uses
```

---

## Analytics Events

All events are fired from `AnalyticsService.instance.*`:

| Event | Trigger |
|-------|---------|
| `onboarding_completed` | Last slide → CTA tapped |
| `onboarding_skipped` | Skip button tapped |
| `sign_in` | Google or anonymous sign-in |
| `paywall_shown` | Paywall modal opened |
| `paywall_converted` | Successful purchase |
| `paywall_dismissed` | Modal closed without purchase |
| `rewarded_ad_shown` | Rewarded ad starts |
| `rewarded_ad_completed` | User earns reward |
| `feature_used` | Gated feature consumed |
| `free_limit_hit` | Daily limit reached |
| `theme_toggled` | Dark/light mode switched |

---

## AdMob Test IDs (Development Only)

| Type | Test Ad Unit ID |
|------|----------------|
| App ID | `ca-app-pub-3940256099942544~3347511713` |
| Banner | `ca-app-pub-3940256099942544/6300978111` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` |

---

## Feature Flags

Control features per-app in `app_config.dart`:

```dart
static const bool enableAiChat = false;    // v1.1
static const bool enableAds = true;        // set false for paid-only apps
static const bool enablePaywall = true;    // set false for fully free apps
```

---

## Checklist Before Publishing

- [ ] `google-services.json` placed (not committed)
- [ ] RevenueCat API key set via `--dart-define`
- [ ] Real AdMob App ID in `AndroidManifest.xml`
- [ ] Real Ad Unit IDs via `--dart-define`
- [ ] App icon replaced (`assets/icons/app_icon.png`)
- [ ] `app_config.dart` updated (name, package, color)
- [ ] `privacyPolicyUrl` and `termsOfServiceUrl` updated
- [ ] Onboarding slides customized
- [ ] `flutter analyze` → 0 issues
- [ ] Tested on real device
- [ ] Play Store listing prepared (ASO)

---

## Tech Stack

| Layer | Tool | Version |
|-------|------|---------|
| Framework | Flutter | stable |
| State | Riverpod | ^2.5 |
| Routing | go_router | ^13 |
| Backend | Firebase | latest |
| Subscription | RevenueCat | ^7.4 |
| Ads | AdMob | ^5.1 |
| AI (text) | OpenAI API | v1.1 |
| AI (vision) | Gemini API | v1.1 |
| CI/CD | Codemagic | — |

---

*Built with ❤️ as an App Factory boilerplate. Ship fast, ship often.*
