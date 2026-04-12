# CodeCraft - Quick Reference

## 🚀 Run Commands

### Android
```bash
# Debug
flutter run

# Release
flutter build apk --release

# Specific device
flutter run -d <device-id>
```

### Web (Chrome)
```bash
flutter run -d chrome
```

### Web (Edge)
```bash
flutter run -d edge
```

### Web (Firefox)
```bash
flutter run -d firefox
```

### All Browsers
```bash
# Terminal 1
flutter run -d chrome

# Terminal 2  
flutter run -d edge

# Terminal 3
flutter run -d firefox
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point
├── firebase_options.dart        # Firebase config (user fills)
├── core/
│   ├── constants/
│   │   ├── app_colors.dart     # Color palette
│   │   ├── app_text_styles.dart # Typography
│   │   └── app_strings.dart    # Strings
│   ├── theme/
│   │   └── app_theme.dart      # App theme
│   ├── router/
│   │   └── app_router.dart     # Navigation routes
│   ├── services/
│   │   ├── gemini_service.dart       # AI Mentor
│   │   ├── groq_service.dart         # Backup AI
│   │   ├── cohere_service.dart       # Search embeddings
│   │   ├── judge0_service.dart       # Code runner
│   │   ├── youtube_service.dart      # Videos
│   │   ├── storage_service.dart      # Local storage
│   │   └── github_service.dart       # GitHub API
│   ├── utils/
│   │   ├── platform_utils.dart       # Platform checks
│   │   ├── helpers.dart              # Utilities
│   │   └── validators.dart           # Input validation
│   └── widgets/                # Reusable components
│       ├── glass_card.dart
│       ├── gradient_button.dart
│       ├── gradient_text.dart
│       ├── tag_chip.dart
│       ├── diff_badge.dart
│       ├── coin_badge.dart
│       ├── streak_row.dart
│       ├── loading_shimmer.dart
│       └── custom_bottom_nav.dart
├── models/
│   ├── user_model.dart
│   ├── problem_model.dart
│   ├── project_model.dart
│   ├── badge_model.dart
│   └── job_model.dart
└── features/
    ├── auth/
    │   ├── screens/
    │   │   ├── splash_screen.dart
    │   │   ├── login_screen.dart
    │   │   ├── signup_screen.dart
    │   │   └── onboarding_screen.dart
    │   └── notifiers/
    │       └── auth_notifier.dart
    ├── home/
    │   ├── screens/
    │   │   └── home_screen.dart
    │   └── notifiers/
    │       └── home_notifier.dart
    ├── roadmap/
    │   ├── screens/
    │   │   ├── roadmap_screen.dart
    │   │   └── topic_detail_screen.dart
    │   └── notifiers/
    │       └── roadmap_notifier.dart
    ├── practice/
    │   ├── screens/
    │   │   ├── practice_screen.dart
    │   │   └── code_editor_screen.dart
    │   └── notifiers/
    │       └── practice_notifier.dart
    ├── projects/
    │   ├── screens/
    │   │   └── projects_screen.dart
    │   └── notifiers/
    │       └── projects_notifier.dart
    ├── ai_mentor/
    │   ├── screens/
    │   │   ├── ai_chat_screen.dart
    │   │   └── camera_scanner_screen.dart
    │   └── notifiers/
    │       └── ai_mentor_notifier.dart
    ├── gamification/
    │   ├── screens/
    │   │   ├── leaderboard_screen.dart
    │   │   └── badges_screen.dart
    │   └── notifiers/
    │       └── gamification_notifier.dart
    └── profile/
        ├── screens/
        │   ├── profile_screen.dart
        │   ├── resume_screen.dart
        │   ├── swag_store_screen.dart
        │   └── mock_interview_screen.dart
        └── notifiers/
            └── profile_notifier.dart
```

---

## 🎨 Color Palette

```dart
AppColors.bg           // #0D0B1F - Main background
AppColors.bgCard       // #13111E - Card background
AppColors.bgSurface    // #1A1730 - Surface background
AppColors.bgInput      // #1E1B35 - Input background

AppColors.purple       // #7C3AED - Primary
AppColors.blue         // #2563EB - Secondary
AppColors.green        // #10B981 - Success
AppColors.pink         // #EC4899 - Accent
AppColors.orange       // #F59E0B - Warning
AppColors.red          // #EF4444 - Error
AppColors.gold         // #FCD34D - Premium

AppColors.textPrimary      // #F8F8FF - Main text
AppColors.textSecondary    // #94A3B8 - Secondary text
AppColors.textHint         // #475569 - Hint text

AppColors.border           // Semi-transparent white
AppColors.borderPurple     // Semi-transparent purple
```

---

## 🧩 Key Widgets

### GlassCard
```dart
GlassCard(
  padding: EdgeInsets.all(16),
  borderColor: AppColors.borderPurple,
  radius: 20,
  gradient: AppColors.gradPurpleBlue,
  onTap: () {},
  child: Text('Card content'),
)
```

### GradientButton
```dart
GradientButton(
  label: 'Submit',
  onTap: () {},
  loading: false,
  disabled: false,
  icon: Icons.send,
  small: false,
)
```

### DiffBadge
```dart
DiffBadge(
  difficulty: 'Medium',  // Easy, Medium, Hard
)
```

### CoinBadge
```dart
CoinBadge(coins: 150)  // Shows 🪙 150
```

### StreakRow
```dart
StreakRow(
  streak: 7,
  activityDays: [true, true, true, false, true, true, true],
  onClaim: () {},
)
```

---

## 📱 Screen Navigation

```
Splash (2.5s)
    ↓
Login/SignUp/Onboarding
    ↓
Home (bottom nav tabs)
├─→ Home Screen
│   └─→ AI Mentor FAB
│   └─→ Mock Interview
│   └─→ Leaderboard
├─→ Roadmap Screen
│   └─→ Topic Detail (YouTube videos)
├─→ Practice Screen
│   └─→ Code Editor (with Judge0)
├─→ Projects Screen
├─→ Profile Screen
    ├─→ Resume
    ├─→ Swag Store
    ├─→ Leaderboard
    └─→ Badges
```

---

## 🔧 Common Tasks

### Add New Screen
1. Create folder: `lib/features/feature_name/screens/`
2. Create notifier: `lib/features/feature_name/notifiers/`
3. Add route in `app_router.dart`
4. Create main screen widget (ConsumerWidget)
5. Import in router

### Add New API Service
1. Create file: `lib/core/services/service_name.dart`
2. Add class with methods
3. Import where needed
4. Use in notifiers

### Add New Color
1. Open `lib/core/constants/app_colors.dart`
2. Add: `static const Color name = Color(0xFFHEXHEX);`
3. Use: `AppColors.name`

### Add New Text Style
1. Open `lib/core/constants/app_text_styles.dart`
2. Add style using GoogleFonts
3. Use: `AppTextStyles.styleName`

---

## 🐛 Debugging

### Enable Debug Logs
```bash
flutter run -v
```

### Check Flutter Version
```bash
flutter --version
```

### Clean Build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build
```

### Check Connected Devices
```bash
flutter devices
```

### Run on Specific Device
```bash
flutter run -d device-id
```

### Hot Reload
```
Press 'r' in terminal
```

### Hot Restart
```
Press 'R' in terminal
```

---

## 🔐 Environment Variables

### Firebase Setup
Set these in `lib/firebase_options.dart`:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',
  projectId: 'your-project-id',
  storageBucket: 'your-project.appspot.com',
  messagingSenderId: 'SENDER_ID',
  appId: 'APP_ID',
);
```

### Android SDK
```gradle
minSdk = 21
targetSdk = 34
```

---

## 📊 Performance Tips

### Reduce APK Size
```bash
flutter build apk --split-per-abi --release
```

### Web Performance
```bash
flutter build web --release --dart-obfuscation
```

### Profile App
```bash
flutter run --profile
```

---

## 🚀 Deployment

### Android Play Store
```bash
flutter build appbundle --release
# Upload to Google Play Console
```

### Web to Firebase
```bash
firebase deploy --only hosting
```

### Web to Netlify
```bash
netlify deploy --prod --dir=build/web
```

---

## 📚 Resources

- [Flutter Docs](https://flutter.dev)
- [Riverpod Docs](https://riverpod.dev)
- [Firebase Docs](https://firebase.google.com/docs/flutter)
- [Go Router](https://pub.dev/packages/go_router)
- [Code samples](https://github.com/flutter/samples)

---

## ✅ Checklist Before Deploy

- [ ] Firebase configured
- [ ] All API keys valid
- [ ] Android permissions set (AndroidManifest.xml)
- [ ] Web config updated (manifest.json, index.html)
- [ ] Tested on real device (Android)
- [ ] Tested on all browsers (Chrome, Edge, Firefox)
- [ ] Privacy policy ready
- [ ] App icon set
- [ ] Build signed APK
- [ ] Deploy web to hosting

---

**Happy Coding! 🚀**
