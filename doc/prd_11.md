# Product Requirements Document: Flutter Core Template

## Version

**Version:** 1.1

**Last Updated:** 2026-05-30

## Product Overview

**Product Vision:** Một Flutter repo nền tối ưu để spawn app mới thật nhanh — từ 3 tuần/app xuống còn 2–5 ngày/app — bằng cách chuẩn hoá toàn bộ infrastructure dùng chung.

**Target Users:** Solo indie dev hoặc nhóm nhỏ (1–3 người) muốn scale nhiều Android apps nhanh theo mô hình "app factory".

**Business Objectives:**
- Giảm thời gian ra app mới từ vài tuần xuống vài ngày
- Tái sử dụng auth, paywall, analytics, onboarding qua tất cả apps
- Tối ưu cho Play Store — Android-first, Firebase-trusted

**Success Metrics:**
- App mới đầu tiên từ template: ≤ 5 ngày
- App thứ 3 trở đi: ≤ 2 ngày
- Clone → reskin → publish pipeline hoạt động không lỗi
- 0 rewrite infrastructure giữa các apps

---

## User Personas

### Persona 1: Solo Indie Dev
- **Demographics:** 20–32 tuổi, lập trình viên full-stack hoặc mobile, thành thạo Flutter
- **Goals:** Launch nhiều niche apps, kiếm passive income qua ads + subscription
- **Pain Points:** Mất quá nhiều thời gian setup auth/paywall/analytics cho mỗi app mới; không có pipeline tái sử dụng code
- **User Journey:** Clone template → đổi niche/branding/prompts → launch → TikTok clips → repeat

### Persona 2: Small App Studio (2–3 người)
- **Demographics:** Team nhỏ, phân chia vai trò dev + design + content
- **Goals:** Manufacture 5–10 apps/năm với chất lượng ổn định
- **Pain Points:** Không nhất quán giữa các apps, khó maintain nhiều codebase
- **User Journey:** 1 người giữ core template, các người còn lại spawn apps từ template

---

## Feature Requirements

| Feature | Mô tả | User Story | Priority | Acceptance Criteria | Dependencies |
|---------|-------|------------|----------|---------------------|--------------|
| **Authentication** | Google login + anonymous login | Là dev, tôi muốn có sẵn auth để không phải viết lại mỗi app | Must | Google Sign-In hoạt động; anonymous login hoạt động; user state persist qua app restart | Firebase Auth |
| **Paywall System** | Subscription modal + free limits + premium gating | Là dev, tôi muốn có sẵn paywall để monetize ngay khi launch | Must | RevenueCat tích hợp; hiển thị modal khi chạm free limit; premium features bị gate đúng | RevenueCat, Firebase |
| **Ad System** | Banner + rewarded + interstitial | Là dev, tôi muốn có sẵn ad logic để kiếm tiền từ free users | Must | AdMob tích hợp; banner hiển thị đúng vị trí; rewarded ad hoạt động với callback | AdMob |
| **Analytics** | Track retention, clicks, conversion | Là dev, tôi muốn track hành vi user để tối ưu app | Must | Firebase Analytics ghi event; crash log qua Crashlytics | Firebase Analytics, Crashlytics |
| **Onboarding** | Carousel + fake premium preview + CTA | Là dev, tôi muốn onboarding tốt để tăng conversion ngay từ đầu | Must | Ít nhất 3 slides; màn hình CTA cuối; có thể skip | — |
| **Settings Screen** | Dark mode, language, privacy policy, restore purchase | Là dev, tôi muốn có sẵn settings để không build lại mỗi lần | Must | Tất cả items hoạt động; restore purchase gọi RevenueCat API | RevenueCat |
| **Theme System** | Light/dark mode + color theming dễ thay | Là dev, tôi muốn đổi màu sắc app chỉ trong 1 file | Should | Thay primary color ở 1 nơi → apply toàn app; dark mode toggle hoạt động | — |
| **AI Chat Module** | Tích hợp OpenAI/Gemini API cho chat feature | Là dev, tôi muốn có sẵn chat UI + API wrapper để plug vào app AI | Should | Chat UI đầy đủ; stream response; error handling | OpenAI API / Gemini API |
| **Notifications** | Push notification setup | Là dev, tôi muốn gửi notification để tăng retention | Should | Firebase Messaging tích hợp; xử lý foreground + background | Firebase Cloud Messaging |
| **Remote Config** | Điều chỉnh config mà không cần update app | Là dev, tôi muốn thay đổi free limits, paywalls từ xa | Could | Firebase Remote Config fetch khi app start; fallback values khi offline | Firebase Remote Config |
| **Localization (i18n)** | Hỗ trợ đa ngôn ngữ qua easy_localization; tối thiểu EN + VI | Là dev, tôi muốn switch ngôn ngữ không cần rebuild để target nhiều thị trường | Should | Tất cả strings trong file `.json` theo ngôn ngữ; Settings → đổi ngôn ngữ → app apply ngay không restart; fallback EN nếu key thiếu | easy_localization |
| **Skeleton Loading States** | Placeholder animation khi data đang load | Là dev, tôi muốn app trông mượt trong lúc fetch data thay vì spinner | Should | Skeleton widget wrap được bất kỳ widget nào; tắt khi data loaded; dùng skeletonizer package | skeletonizer |
| **In-App Update** | Nhắc user update khi có version mới trên Play Store | Là dev, tôi muốn user luôn dùng version mới nhất để tránh bug cũ | Could | Kiểm tra version khi app start; hiện dialog nếu có update; flexible update (không bắt buộc) | in_app_update / app_update |

---

## User Flows

### Flow 1: Spawn App Mới Từ Template
1. Clone core template repo
2. Đổi package name, app name, colors trong `app_config.dart`
3. Thay assets (icon, splash, fonts)
4. Cập nhật prompts / feature module phù hợp niche
5. Kết nối Firebase project mới
6. Kết nối RevenueCat + AdMob account
7. Build & test trên device
8. Deploy lên Play Store (internal testing → production)

### Flow 2: Onboarding User Mới
1. App mở → Splash screen
2. Kiểm tra: user đã login chưa?
   - Chưa → Onboarding carousel (3 slides)
   - Rồi → Vào màn hình chính
3. Slide cuối onboarding → CTA: "Bắt đầu miễn phí" hoặc "Dùng Premium"
   - Chọn Premium → Paywall modal
   - Chọn Free → anonymous login → vào app
4. Màn hình chính

### Flow 3: Chạm Free Limit → Upsell
1. User thực hiện action (ví dụ: gửi tin nhắn AI lần thứ 6)
2. Kiểm tra free limit (5 lần/ngày)
3. Limit reached → Hiển thị paywall modal
   - Subscribe → RevenueCat xử lý → unlock premium
   - Dismiss → Hiện rewarded ad để nhận thêm lượt
   - Bỏ qua → Không cho dùng feature

---

## Non-Functional Requirements

### Performance
- **Load Time:** App cold start < 2 giây
- **Response Time:** AI API response stream bắt đầu hiển thị < 1 giây sau khi gửi
- **Offline:** App không crash khi mất mạng; hiển thị trạng thái offline rõ ràng

### Security
- **Authentication:** Firebase Auth — token tự refresh; không lưu password thủ công
- **Sensitive Storage:** `flutter_secure_storage` cho auth tokens và bất kỳ key nào không được để plain text; không dùng Hive/SharedPrefs cho sensitive data
- **API Keys — Local Dev:** `flutter_dotenv` load từ `.env` file; `.env` trong `.gitignore`; `.env.example` có sẵn trong repo với key names nhưng không có values
- **API Keys — Production:** Keys inject qua CI/CD environment variables (Codemagic secrets); không bao giờ hardcode trong source hoặc commit lên git
- **AI API Calls:** Các calls đến OpenAI/Gemini nên qua Firebase Functions proxy — không expose keys ở client
- **Data Protection:** Không lưu conversation AI trên device nếu không cần thiết

### Compatibility
- **Devices:** Android 7.0+ (API 24+)
- **Screen Sizes:** Hỗ trợ phone (360dp–480dp width) và tablet cơ bản
- **Orientation:** Portrait chính; landscape optional tuỳ app

### Accessibility
- **Text Scaling:** UI không vỡ khi tăng text size 150%
- **Contrast:** Màu text đạt WCAG AA tối thiểu

---

## Technical Specifications

### File Structure

```
/core_template
  /lib
    /core
      /analytics          ← Firebase Analytics wrapper
      /auth               ← Firebase Auth (Google + anonymous)
      /paywall            ← RevenueCat integration
      /ads                ← AdMob (banner, rewarded, interstitial)
      /onboarding         ← Carousel + CTA screens
      /settings           ← Settings screen (language, dark mode, restore)
      /notifications      ← Firebase Messaging
      /remote_config      ← Firebase Remote Config
      /secure_storage     ← flutter_secure_storage wrapper (tokens, sensitive keys)
      /update             ← In-app update check (in_app_update)
    /shared_ui
      /buttons
      /cards
      /dialogs
      /skeleton           ← Skeleton loading wrappers (skeletonizer)
      /theme              ← AppTheme, color tokens, dark mode, ScreenUtil init
    /features
      /ai_chat            ← OpenAI/Gemini chat module
      /tracking           ← Habit/progress tracking (optional)
      /dashboard          ← Home dashboard shell
    /config
      app_config.dart     ← Tên app, màu, limits — ĐỔI Ở ĐÂY
  /assets
    /icons
    /images
    /fonts
  /l10n                  ← Localization strings
    /en.json             ← English (default)
    /vi.json             ← Vietnamese
  /firebase              ← google-services.json (không commit lên git)
  .env                   ← API keys local (không commit — dùng .gitignore)
  .env.example           ← Template cho team biết keys cần có
  pubspec.yaml
  README.md              ← Hướng dẫn spawn app mới
```

### Frontend
- **Framework:** Flutter (stable channel)
- **Architecture:** Feature-first — code nhóm theo feature, không theo layer; dễ xoá/thêm feature khi spawn app mới
- **State Management:** Riverpod
- **Routing:** go_router
- **Local DB:** Hive hoặc Isar
- **Network:** Dio (với interceptors cho auth token + logging)
- **Responsive Sizing:** `flutter_screenutil` — tất cả sizes/spacing dùng `.sp`, `.w`, `.h`; init 1 lần trong `app_config.dart`; không bao giờ hardcode pixel
- **Localization:** `easy_localization` — strings trong `/l10n/en.json` và `/l10n/vi.json`; thêm ngôn ngữ mới không cần sửa code
- **Loading States:** `skeletonizer` — wrap widget bất kỳ để có skeleton placeholder; dùng thay spinner ở màn hình list/card
- **Secure Storage:** `flutter_secure_storage` — lưu auth tokens, RevenueCat user ID, API keys nhạy cảm; không dùng SharedPreferences cho sensitive data
- **Environment Variables:** `flutter_dotenv` — load `.env` local khi dev; production keys qua CI/CD environment; `.env.example` commit lên git, `.env` thật thì không
- **Icon Pack:** Iconsax Plus (default) — linear/bold styles, consistent across apps; thay thế hoặc bổ sung Flutter Icons mặc định
- **Design System:** Custom theme system dựa trên Material 3; token màu trong 1 file; tất cả text styles qua `AppTheme.textTheme`

### Backend
- **Platform:** Firebase (Auth, Firestore, Storage, Functions, Analytics, Crashlytics, Remote Config)
- **AI API:** OpenAI API (text/chat), Gemini API (vision/OCR), Deepgram hoặc Whisper (voice)
- **Monetization:** RevenueCat (subscription), AdMob (ads)

### Infrastructure
- **Hosting:** Firebase Hosting (landing page optional)
- **CI/CD:** Codemagic — build Flutter Android, sign, deploy ke Play Store
- **App Signing:** Google Play App Signing
- **Internal Testing:** Firebase App Distribution

---

## Analytics & Monitoring

**Key Metrics:**
- D1 / D7 / D30 retention
- Paywall impression rate và conversion rate
- Rewarded ad completion rate
- Free limit hit rate per user

**Events cần track:**
- `onboarding_completed`
- `paywall_shown` / `paywall_converted` / `paywall_dismissed`
- `rewarded_ad_shown` / `rewarded_ad_completed`
- `feature_used` (với feature name)
- `free_limit_hit`

**Monitoring:**
- Firebase Crashlytics: alert khi crash rate > 1%
- PostHog (optional): funnel analysis chi tiết hơn

---

## Release Planning

### MVP — Core Template v1.0
**Features:**
- Auth (Google + anonymous)
- Paywall (RevenueCat)
- Ads (AdMob — banner + rewarded)
- Analytics (Firebase)
- Onboarding (3 slides + CTA)
- Settings (dark mode, language switcher, privacy policy, restore purchase)
- Theme system (đổi màu 1 chỗ)
- Responsive sizing (ScreenUtil init + sizing conventions)
- Localization (EN + VI strings via easy_localization)
- Skeleton loading states (skeletonizer trên các màn hình data)
- Secure storage wrapper (flutter_secure_storage)
- Dotenv setup (.env + .env.example + CI/CD pattern)
- Icon pack (Iconsax Plus configured)

**Timeline:** 2–3 tuần để build và test kỹ

**Success Criteria:** Spawn được app thứ nhất từ template trong ≤ 5 ngày

---

### v1.1 — AI Module
- AI Chat module (OpenAI/Gemini)
- Voice input (Deepgram/Whisper)
- Prompt management system

---

### v1.2 — Growth Tools
- ASO screenshot generator guide
- Remote Config cho free limits
- Notification templates

---

### v2.0 — Multi-App Monorepo
- Chuyển sang monorepo structure (`/apps`, `/packages`)
- Shared packages: `ui_kit`, `analytics`, `paywall`, `shared_widgets`
- CI/CD pipeline tự động cho nhiều apps

---

## Open Questions & Assumptions

- **Question 1:** Có dùng Flavor system để quản lý nhiều apps trong 1 repo không, hay vẫn clone riêng?
- **Question 2:** AI module dùng server-side proxy hay gọi thẳng từ client? (liên quan đến bảo mật API key)
- **Question 3:** Localization scope cho MVP: chỉ EN + VI, hay thêm ngôn ngữ khác từ đầu? easy_localization cho phép thêm sau dễ dàng nhưng nên seed ít nhất 2 ngôn ngữ ngay từ v1.0
- **Question 4:** ScreenUtil base design size là bao nhiêu? Gợi ý: 390×844 (iPhone 14 size) để đồng nhất giữa các apps trong factory
- **Assumption 1:** Android-first; iOS sẽ thêm sau khi có doanh thu ổn định
- **Assumption 2:** Mỗi app dùng Firebase project riêng (không share Firestore data giữa apps)
- **Assumption 3:** RevenueCat và AdMob account đã có sẵn trước khi spawn app mới
- **Assumption 4:** `.env` chỉ dùng cho local dev; production hoàn toàn dùng CI/CD secrets — không có `.env` file trên server

---

## Appendix

### Competitive Analysis
- **AppGyver / FlutterFlow:** Low-code nhưng khó customize sâu; không phù hợp app factory
- **Indie dev templates trên GitHub:** Thường thiếu paywall hoặc ads; không có hướng dẫn spawn nhanh

### Tech Stack Summary

| Layer | Tool |
|-------|------|
| Framework | Flutter (stable, feature-first architecture) |
| State | Riverpod |
| Routing | go_router |
| Responsive | flutter_screenutil |
| Localization | easy_localization |
| Loading States | skeletonizer |
| Secure Storage | flutter_secure_storage |
| Env Variables | flutter_dotenv |
| Icon Pack | Iconsax Plus |
| Backend | Firebase |
| Subscription | RevenueCat |
| Ads | AdMob |
| AI (text) | OpenAI API |
| AI (vision) | Gemini API |
| AI (voice) | Deepgram / Whisper |
| CI/CD | Codemagic |
| Analytics+ | PostHog (optional) |
| In-App Update | in_app_update |
| Coding Agent | Antigravity + Cursor / Claude Code |

### Glossary
- **Core Template:** Repo Flutter nền với toàn bộ infrastructure có sẵn; chỉ cần thay niche + branding để ra app mới
- **App Factory:** Mindset và quy trình sản xuất nhiều apps nhanh từ 1 template
- **Spawn:** Tạo app mới từ core template (clone → reskin → deploy)
- **Free Limit:** Số lần user miễn phí được dùng 1 tính năng trước khi bị gate bởi paywall
- **ASO:** App Store Optimization — tối ưu keyword, tên app, screenshots để tăng organic installs
- **Paywall Gating:** Chặn truy cập feature premium cho user chưa subscribe
- **ScreenUtil:** Package responsive sizing — dùng `.sp/.w/.h` thay pixel cứng; đảm bảo UI đúng trên mọi screen size
- **easy_localization:** Package i18n — strings lưu trong JSON file theo ngôn ngữ; switch ngôn ngữ runtime không cần rebuild
- **skeletonizer:** Package wrap widget bất kỳ để hiển thị skeleton loading placeholder thay vì spinner
- **flutter_dotenv:** Load environment variables từ `.env` file; tách biệt config local dev vs production
- **flutter_secure_storage:** Lưu sensitive data (tokens, keys) trong Android Keystore / iOS Keychain; an toàn hơn SharedPreferences
- **Feature-first Architecture:** Cấu trúc thư mục nhóm theo feature (`/auth`, `/paywall`, `/ai_chat`) thay vì theo layer (`/models`, `/views`, `/controllers`); dễ xoá/thêm feature khi spawn app mới