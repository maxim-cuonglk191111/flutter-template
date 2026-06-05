# Product Requirements Document: Anime Pomodoro Focus App

## Product Overview

**Product Vision:** Một focus timer app có visual aesthetic anime/pixel art, nhắm vào học sinh và cộng đồng anime — kết hợp Pomodoro technique với ambient sounds và streak system để tạo trải nghiệm học tập thú vị và có retention cao.

**Target Users:** Học sinh THPT và đại học (15–24 tuổi), fan anime, người dùng lofi study content trên YouTube/TikTok.

**Business Objectives:**
- Launch nhanh trong 1 tuần bằng cách recycle Flutter repos có sẵn
- Kiếm tiền qua AdMob (free users) + premium themes/sound packs (subscribers)
- Tận dụng organic traffic từ TikTok, Pinterest, YouTube Shorts

**Success Metrics:**
- D7 retention ≥ 20%
- Session completion rate ≥ 60% (user bắt đầu Pomodoro và hoàn thành)
- AdMob eCPM ổn định sau tuần đầu
- ≥ 500 installs trong 30 ngày đầu (organic)

---

## User Personas

### Persona 1: Học Sinh Ôn Thi
- **Demographics:** 16–22 tuổi, dùng Android, xem lofi study stream trên YouTube
- **Goals:** Tập trung học 2–4 tiếng/ngày, track tiến độ, không bị distract
- **Pain Points:** Timer thông thường quá nhàm; thiếu động lực học một mình
- **User Journey:** Thấy TikTok clip aesthetic → tải app → chọn theme → bật ambient sound → bắt đầu Pomodoro → xem streak sau 1 tuần

### Persona 2: Anime Fan / Aesthetic Collector
- **Demographics:** 15–25 tuổi, thích pixel art, lo-fi, cottagecore, dark academia
- **Goals:** Có app trên điện thoại vừa đẹp vừa hữu ích; flex setup học trên TikTok
- **Pain Points:** App Pomodoro phổ biến quá generic, không có "vibe"
- **User Journey:** Thấy screenshot đẹp trên Pinterest → tải → screenshot màn hình timer → đăng story → kéo thêm installs

---

## Feature Requirements

| Feature | Mô tả | User Story | Priority | Acceptance Criteria | Dependencies |
|---------|-------|------------|----------|---------------------|--------------|
| **Pomodoro Timer** | Visual countdown timer (25/5 phút mặc định), có animation | Là học sinh, tôi muốn timer trực quan để biết còn bao nhiêu phút | Must | Timer đếm ngược đúng; có animation fill/ring; tự chuyển work→break; notification khi hết giờ | — |
| **Digital Timer Display** | Hiển thị MM:SS dạng số kèm visual | Là user, tôi muốn thấy cả số lẫn animation để dễ theo dõi | Must | Hiển thị đồng thời visual ring + số; font aesthetic | — |
| **Anime / Pixel Art Themes** | Bộ theme thay đổi background, màu sắc, nhân vật pixel | Là fan anime, tôi muốn chọn theme yêu thích để học vui hơn | Must | ≥ 3 free themes; ≥ 5 premium themes; áp dụng ngay khi chọn | — |
| **Ambient Sounds** | Background audio: rain, lofi, café, forest, white noise | Là user, tôi muốn bật âm thanh nền để tập trung hơn | Must | ≥ 2 sound packs miễn phí; audio chạy nền khi tắt màn hình; có volume slider | — |
| **Study Streaks** | Đếm số ngày liên tiếp hoàn thành ≥ 1 Pomodoro | Là học sinh, tôi muốn thấy streak để có động lực học mỗi ngày | Must | Streak tăng khi hoàn thành session trong ngày; reset nếu bỏ 1 ngày; hiển thị trên màn hình chính | Hive local DB |
| **Daily Goals** | Đặt mục tiêu số Pomodoro/ngày | Là user, tôi muốn tự đặt mục tiêu để biết hôm nay học đủ chưa | Must | Default 4 Pomodoros/ngày; có thể chỉnh 1–12; progress bar hiển thị hôm nay đạt bao nhiêu % | — |
| **Session History** | Lịch sử các session đã học | Là user, tôi muốn xem lại lịch sử để biết mình đã học bao nhiêu | Must | Hiển thị theo ngày; số Pomodoros + tổng thời gian; lưu local | Hive local DB |
| **AdMob Ads** | Banner + interstitial sau mỗi break | Là dev, tôi muốn có ads để kiếm tiền từ free users | Must | Banner ở bottom; interstitial hiện sau break session (không phải trong lúc học); không block UX khi đang focus | AdMob |
| **Premium Themes** | Mở khoá theme đặc biệt qua subscription/one-time | Là dev, tôi muốn monetize qua premium themes | Should | Themes premium có lock icon; tap → paywall; unlock sau purchase | RevenueCat |
| **Premium Sound Packs** | Mở khoá thêm ambient sounds | Là dev, tôi muốn bán sound packs cho heavy users | Should | ≥ 3 sound packs premium; preview ngắn 5 giây trước khi mua | RevenueCat |
| **Custom Timer Settings** | Chỉnh thời gian work/short break/long break | Là user power, tôi muốn tuỳ chỉnh thời gian Pomodoro | Could | Work: 15–60 phút; Short break: 3–15 phút; Long break: 10–30 phút | — |
| **Widget (Home Screen)** | Widget timer nhỏ trên màn hình chính | Là user, tôi muốn xem timer mà không cần mở app | Could | Widget hiển thị countdown + streak | — |

---

## User Flows

### Flow 1: First Launch
1. Splash screen (anime pixel art logo, 1.5 giây)
2. Onboarding — 3 slides:
   - Slide 1: "Focus like a hero" — giới thiệu timer
   - Slide 2: "Your vibe, your theme" — preview themes
   - Slide 3: "Build your streak" — giới thiệu streak system
3. CTA: "Bắt đầu học" → vào app (không cần login)
4. Màn hình chính với timer sẵn sàng

### Flow 2: Pomodoro Session
1. Màn hình chính → chọn theme + sound (optional)
2. Nhấn "Bắt đầu" → timer đếm ngược 25 phút
3. Animation + sound chạy
4. Hết 25 phút → notification + animation kết thúc
5. Màn hình Break (5 phút) → **interstitial ad hiển thị**
6. Hết break → tự động quay lại session mới
7. Sau 4 Pomodoros → Long break (15 phút)
8. Session lưu vào history; streak + daily goal cập nhật

### Flow 3: Theme Selection → Premium Upsell
1. Màn hình chính → icon Theme
2. Theme picker hiển thị: free themes (unlocked) + premium themes (có lock)
3. Tap theme free → áp dụng ngay
4. Tap theme premium → preview 3 giây → paywall modal
   - "Unlock All Themes – 39k/tháng" hoặc "Mua theme này – 19k"
   - Subscribe → RevenueCat xử lý → unlock
   - Dismiss → quay lại theme picker

### Flow 4: Sound Pack Upsell
1. Màn hình chính → icon Sound
2. Sound picker: 2 packs free + packs premium có lock
3. Tap premium pack → preview 5 giây → paywall
4. Subscribe/purchase → unlock

---

## Non-Functional Requirements

### Performance
- **Cold Start:** < 1.5 giây đến màn hình chính
- **Timer Accuracy:** Sai số < 1 giây sau 25 phút
- **Audio:** Không bị ngắt khi có notification; tiếp tục khi màn hình tắt
- **Offline:** Toàn bộ tính năng core hoạt động không cần mạng (trừ ads)

### Security
- **No Login Required:** Data lưu local (Hive); không cần account để dùng cơ bản
- **Sensitive Storage:** `flutter_secure_storage` lưu RevenueCat user ID và unlock status; không để plain text trong SharedPrefs
- **API Keys — Local Dev:** `flutter_dotenv` load từ `.env`; `.env` trong `.gitignore`; `.env.example` commit lên repo với key names
- **API Keys — Production:** AdMob App ID và RevenueCat API key inject qua Codemagic environment secrets; không hardcode trong source

### Compatibility
- **Android:** API 24+ (Android 7.0)
- **Screen Sizes:** 360dp–480dp width; không vỡ layout ở tablet
- **Orientation:** Portrait only

### Accessibility
- **Text Size:** Không vỡ layout khi tăng font system lên 130%
- **Contrast:** Timer countdown đủ contrast để đọc trong ánh sáng mạnh

---

## Technical Specifications

### File Structure

```
/anime_pomodoro
  /lib
    /core                     ← Recycle từ core_template
      /ads                    ← AdMob (banner + interstitial)
      /paywall                ← RevenueCat
      /analytics              ← Firebase Analytics
      /notifications          ← Local notifications (khi hết giờ)
      /onboarding
      /settings
      /secure_storage         ← flutter_secure_storage wrapper (RevenueCat user ID, unlock state)
      /update                 ← in_app_update check khi app start

    /features
      /timer
        timer_screen.dart
        timer_controller.dart  ← Riverpod provider
        pomodoro_logic.dart
      /themes
        theme_picker.dart
        theme_model.dart
        themes_data.dart       ← Danh sách free + premium themes
      /sounds
        sound_picker.dart
        sound_player.dart      ← just_audio wrapper
        sounds_data.dart       ← Danh sách sound packs
      /history
        history_screen.dart
        session_model.dart
      /streak
        streak_widget.dart
        streak_service.dart

    /shared_ui
      /widgets
        ring_timer_widget.dart ← Custom paint animation
        streak_badge.dart
        goal_progress_bar.dart
      /skeleton               ← skeletonizer wrappers (theme picker, history list)
    /config
      app_config.dart          ← Tên app, màu chính, Pomodoro defaults; ScreenUtil base size

  /assets
    /themes                    ← Background images/pixel art per theme
    /sounds                    ← Audio files (lofi, rain, café…)
    /icons
    /fonts                     ← Aesthetic pixel/retro font

  /l10n
    en.json                    ← English strings (default)
    vi.json                    ← Vietnamese strings

  .env                         ← AdMob ID, RevenueCat key — local dev (không commit)
  .env.example                 ← Key names template cho team
  pubspec.yaml
```

### Frontend
- **Framework:** Flutter (stable)
- **Architecture:** Feature-first — mỗi feature là 1 folder độc lập; dễ bật/tắt khi spawn app mới
- **State Management:** Riverpod
- **Routing:** go_router
- **Local DB:** Hive (session history, streak, settings)
- **Responsive Sizing:** `flutter_screenutil` — tất cả sizes/spacing dùng `.sp/.w/.h`; base 390×844; đảm bảo ring timer đẹp trên mọi màn hình
- **Localization:** `easy_localization` — EN + VI; strings trong `/l10n/en.json` và `/l10n/vi.json`; Settings → language switcher
- **Loading States:** `skeletonizer` — theme picker và history list dùng skeleton khi load lần đầu
- **Secure Storage:** `flutter_secure_storage` — RevenueCat user ID và premium unlock state
- **Environment Variables:** `flutter_dotenv` — AdMob App ID, RevenueCat key; `.env` local, CI/CD secrets cho production
- **Icon Pack:** Iconsax Plus — icons cho navigation, settings, streak badges; thay thế default Flutter icons
- **Audio:** just_audio (background playback, audio session)
- **Timer Animation:** CustomPainter (ring countdown)
- **Local Notifications:** flutter_local_notifications
- **In-App Update:** `in_app_update` — check flexible update khi app start
- **Design:** Dark-first aesthetic; pixel art assets; accent colors per theme; tất cả text styles qua AppTheme

### Backend
- **Firebase:** Analytics + Crashlytics (không cần Firestore — data lưu local)
- **RevenueCat:** Subscription + one-time purchase cho themes/sounds
- **AdMob:** Banner bottom + interstitial tại break time

### Repos To Recycle
1. **Flutter Pomodoro apps** — timer logic, ring animation, break flow
2. **Flutter Timer templates** — countdown UI, notification integration
3. **Flutter Music Player UI** — audio player controls, playlist/pack picker UI

**Search keywords để tìm:**
- `flutter pomodoro`
- `flutter focus timer`
- `flutter study app`
- `flutter lofi player`

### Infrastructure
- **CI/CD:** Codemagic (build + sign + deploy)
- **Internal Testing:** Firebase App Distribution
- **App Signing:** Google Play App Signing

---

## Analytics & Monitoring

**Key Events:**
- `session_started` / `session_completed` / `session_abandoned`
- `break_started` (trigger interstitial)
- `theme_changed` (free vs premium)
- `sound_pack_selected` (free vs premium)
- `paywall_shown` / `paywall_converted` / `paywall_dismissed`
- `streak_milestone` (3, 7, 14, 30 ngày)
- `daily_goal_completed`

**Metrics cần watch:**
- Session completion rate (target ≥ 60%)
- Paywall conversion rate (target ≥ 3%)
- D1 / D7 retention
- AdMob interstitial fill rate + eCPM

---

## Monetization Detail

| Source | Trigger | Free / Premium |
|--------|---------|----------------|
| AdMob Banner | Luôn hiển thị (bottom) | Free users |
| AdMob Interstitial | Sau mỗi break session | Free users |
| Premium Themes | Tap locked theme | Premium |
| Premium Sound Packs | Tap locked sound pack | Premium |
| Weekly/Monthly Sub | Paywall modal | Premium (unlock all) |

**Pricing suggestion:**
- Gói tháng: 29.000–39.000 VND
- One-time theme: 9.000–19.000 VND
- One-time sound pack: 9.000–19.000 VND

---

## Distribution Strategy

### TikTok (Primary)
- Clip 10–15 giây: "POV: this app fixed my study addiction"
- Show: timer animation → ambient sound → streak counter → aesthetic UI
- Hook visual mạnh trong 2 giây đầu
- Post 5 clips/app, test hooks khác nhau

### Pinterest
- Screenshot aesthetic của từng theme
- Board: "Anime Study Setup", "Lofi Study Apps", "Cute Timer App"

### YouTube Shorts
- "Band 5 → study 4 hours straight using this app"
- Study with me format với timer visible

### ASO (App Store Optimization)
- **Tên app:** "Anime Study Timer – Pomodoro" hoặc "Cute Focus Timer: Lofi Pomodoro"
- **Keywords:** anime pomodoro, cute study timer, lofi focus timer, pixel art timer, study streak app
- **Screenshots:** Dark aesthetic, timer ring to, ambient sound UI, streak badge

---

## Release Planning

### MVP v1.0 — Target: 1 tuần build
**Features:**
- Pomodoro timer (visual ring + digital)
- 3 free themes (1 dark anime, 1 pixel forest, 1 lo-fi room)
- 2 free sound packs (rain, lofi beats)
- Study streak
- Daily goal (default 4 Pomodoros)
- Session history
- AdMob (banner + interstitial)
- Onboarding (3 slides)
- Settings (custom timer, dark mode, language EN/VI)
- Responsive sizing (ScreenUtil — ring timer đẹp trên mọi screen)
- Localization EN + VI (easy_localization)
- Skeleton loading (theme picker + history)
- Secure storage (RevenueCat user ID)
- Dotenv setup (.env + .env.example)
- Iconsax Plus icon pack
- In-app update check

**Success Criteria:** 500 installs trong 30 ngày; D7 retention ≥ 20%

---

### v1.1 — Premium Unlock
- 5 thêm premium themes
- 3 thêm sound packs premium
- RevenueCat subscription flow
- Paywall modal đẹp

---

### v1.2 — Engagement
- Weekly report (tổng giờ học/tuần)
- Streak milestone badges
- Widget màn hình chính

---

### v2.0 — Social / Gamification
- Share streak lên story
- Study challenges (7-day, 30-day)
- Leaderboard (optional)

---

## Open Questions & Assumptions

- **Question 1:** Dùng audio files local (bundled trong app) hay stream từ URL? (local = nhanh hơn, không cần mạng; nhưng tăng app size)
- **Question 2:** RevenueCat subscription hay one-time purchase cho themes? (subscription = LTV cao hơn; one-time = conversion dễ hơn)
- **Assumption 1:** Không cần login — data lưu local; user không sync giữa devices
- **Assumption 2:** Audio files bundled trong app (< 15MB total để không bị cảnh báo size trên Play Store)
- **Assumption 3:** AdMob interstitial chỉ hiện sau break, không bao giờ interrupt session đang chạy

---

## Appendix

### Competitive Analysis
| App | Điểm mạnh | Điểm yếu |
|-----|-----------|----------|
| Forest | Gamification tốt | Không có anime aesthetic |
| Engross | Clean UI | Quá minimal, không có "vibe" |
| Focus To-Do | Feature nhiều | Phức tạp, không aesthetic |
| PomoFocus (web) | Đơn giản | Không có mobile app tốt |

**Cơ hội:** Không có app Pomodoro nào trên Play Store có anime pixel art aesthetic + ambient sounds tốt.

### Approval Difficulty
- **Mức độ:** Easy
- **Lý do:** App utility đơn giản; không có user-generated content; Firebase-backed (Google trust); không có tính năng nhạy cảm

### Estimated Build Time
- **Core timer + themes + sounds:** 3 ngày
- **AdMob + RevenueCat tích hợp (từ core template):** 1 ngày
- **Onboarding + settings + polish:** 1 ngày
- **Test + fix + submit:** 0.5–1 ngày
- **Tổng:** ~1 tuần

### Glossary
- **Pomodoro:** Kỹ thuật quản lý thời gian: 25 phút tập trung → 5 phút nghỉ, lặp lại
- **Session:** 1 lần chạy timer 25 phút hoàn chỉnh
- **Streak:** Số ngày liên tiếp hoàn thành ít nhất 1 Pomodoro
- **Theme:** Bộ visual (background, màu sắc, pixel art) thay đổi giao diện app
- **Sound Pack:** Nhóm ambient sounds cùng chủ đề (ví dụ: "Rain & Thunder", "Lofi Café")
- **Paywall Gating:** Khoá tính năng premium cho đến khi user mua/subscribe
- **ScreenUtil:** Package responsive sizing — `.sp/.w/.h` thay pixel cứng; ring timer và layout đúng trên mọi màn hình
- **easy_localization:** Hệ thống i18n — strings trong JSON file; switch EN/VI runtime không rebuild
- **skeletonizer:** Loading placeholder đẹp cho theme picker và history list thay vì spinner
- **flutter_dotenv:** Load API keys từ `.env` khi dev local; production dùng CI/CD secrets
- **flutter_secure_storage:** Lưu RevenueCat user ID và unlock state an toàn trong Android Keystore
- **Feature-first:** Cấu trúc thư mục theo feature (`/timer`, `/themes`, `/sounds`); dễ bật/tắt khi spawn app mới từ template
