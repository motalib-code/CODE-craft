# CodeCraft - Deployment Guide

Complete step-by-step guide to deploy CodeCraft on Android & Web.

---

## 📋 Prerequisites

### System Requirements
- Flutter 3.2+ installed
- Dart 3.2+ installed
- Android SDK 21+ (for Android)
- Java 17+
- Node.js 18+ (for web hosting)

### Accounts Needed
- [ ] Firebase project
- [ ] Google Play Console (for Android)
- [ ] Web hosting (Firebase/Netlify/Vercel)

---

## 🔥 Step 1: Firebase Setup (REQUIRED)

### Method A: Using flutterfire CLI (Recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install flutterfire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Flutter project
flutterfire configure

# Follow prompts:
# 1. Select/create Firebase project
# 2. Enable Android support
# 3. Enable Web support
```

This auto-generates `lib/firebase_options.dart`

### Method B: Manual Setup

1. Create Firebase project:
   - Go to https://console.firebase.google.com
   - Click "Create Project"
   - Name: "CodeCraft"
   - Accept terms & create

2. Enable Authentication:
   - Go to Authentication → Sign-in method
   - Enable "Google"
   - Enable "Email/Password"

3. Create Firestore Database:
   - Go to Firestore Database
   - Create database in test mode
   - Choose region (us-central1)

4. Add Android App:
   - Project Settings → Add Android app
   - Package name: `com.codecraft.codecraft`
   - Download `google-services.json`
   - Place in `android/app/google-services.json`

5. Add Web App:
   - Project Settings → Add Web app
   - Copy Firebase config
   - Update `lib/firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY_HERE',
  authDomain: 'your-project-id.firebaseapp.com',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  appId: '1:YOUR_APP_ID:web:YOUR_WEB_APP_ID',
  measurementId: 'G-YOUR_MEASUREMENT_ID',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY_HERE',
  appId: '1:YOUR_APP_ID:android:YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

---

## 📱 Step 2: Android Build & Deployment

### Create Signing Key (One-time)

```bash
# Generate keystore
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias codecraft-key

# When prompted:
# - Password: (create password)
# - First name: CodeCraft
# - Company: Your Name
# - City: Your City
# - Country: IN
```

### Update Build Config

**File**: `android/key.properties` (create if doesn't exist)

```properties
storePassword=your_password_here
keyPassword=your_password_here
keyAlias=codecraft-key
storeFile=/path/to/key.jks
```

**Windows path example**:
```
storeFile=C:\\Users\\YourUsername\\key.jks
```

### Build Release APK

```bash
# Build split APKs (recommended for Play Store)
flutter build apk --split-per-abi --release

# OR single universal APK
flutter build apk --release
```

**Output files**:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (armv7)
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (arm64) ⭐
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (x86_64)
- `build/app/outputs/flutter-apk/app-release.apk` (universal)

### Test APK Locally

```bash
# Install on connected device
adb install build/app/outputs/flutter-apk/app-release.apk

# Or copy to device and install manually
```

### Upload to Play Store

1. Create Google Play Developer Account
   - Go to https://play.google.com/apps/publish
   - Pay $25 one-time fee
   - Complete developer profile

2. Create App Entry
   - Click "Create app"
   - Language: English
   - App name: CodeCraft
   - Category: Education
   - Click "Create"

3. Upload APKs
   - Go to internal testing track
   - Upload APK file
   - Add release notes
   - Review & save

4. Publish
   - Apps & Games → CodeCraft
   - Production tab → Create release
   - Upload signed APKs
   - Add screenshot & description
   - Submit for review (24-48 hours)

---

## 🌐 Step 3: Web Deployment

### Build Production Web

```bash
# Optimize build
flutter build web --release --dart-obfuscation

# Output: build/web/
```

### Deploy to Firebase Hosting (FREE)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize hosting
firebase init hosting

# When prompted:
# - Project: Select CodeCraft project
# - Public directory: build/web
# - Single-page app: Yes (y)
# - Overwrite index.html: No (n)

# Deploy
firebase deploy --only hosting
```

**Live at**: `https://codecraft-xxxxx.web.app`

### Deploy to Netlify (Alternative)

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Build web
flutter build web --release

# Deploy
netlify deploy --prod --dir=build/web

# Or drag build/web folder to https://app.netlify.com
```

### Deploy to Vercel (Alternative)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod

# Follow prompts for configuration
```

---

## 📸 Add App Store Assets

### Android Icon
```
android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
(1024x1024 PNG)
```

### Screenshots
For Play Store:
- Minimum: 2 screenshots
- Format: PNG/JPEG  
- Aspect ratio: 9:16
- Max size: 8 MB each

Create using:
```bash
flutter screenshots
# Requires screenshots.yaml config
```

---

## 🧪 Pre-Launch Testing

### Android Testing
```bash
# Debug build (for initial testing)
flutter build apk --debug more time

# Install debug APK
flutter run --release  

# Test features:
# - [ ] Tap through all screens
# - [ ] Try login/signup
# - [ ] Test code editor
# - [ ] Test AI chat
# - [ ] Test offline mode (toggle Wi-Fi)
# - [ ] Check permissions (camera, storage)
# - [ ] Check crash logs
adb logcat | grep Flutter
```

### Web Testing
```bash
# Test on all browsers:
flutter run -d chrome
flutter run -d edge  
flutter run -d firefox

# Check:
# - [ ] All buttons work
# - [ ] Layout responsive
# - [ ] No console errors (F12)
# - [ ] Camera scanner works (file upload)
# - [ ] AI chat responds quickly
# - [ ] Performance good (no lag)
```

### Cross-Device Testing
```bash
# Test on multiple phones:
flutter run -d device-1
flutter run -d device-2

# Or use emulator:
flutter emulators --launch Pixel_4_API_33
flutter run
```

---

## 📊 Performance Optimization

### Reduce APK Size

```bash
# Check APK content
flutter build apk --analyze-size --release

# Use split APKs (recommended)
flutter build apk --split-per-abi --release

# Expected sizes:
# - arm64: ~45 MB
# - armv7: ~40 MB
# - x86_64: ~45 MB
```

### Web Size

```bash
# Before optimization
flutter build web --release
# Check: build/web/main.dart.js size

# With obfuscation (smaller but slower to build)
flutter build web --release --dart-obfuscation

# Expected: ~4-5 MB main.dart.js
```

### App Performance

```bash
# Profile app
flutter run --profile

# Check:
# - Frame rate (target: 60 FPS)
# - Memory usage
# - CPU usage
```

---

## 🔒 Production Checklist

### Before Submitting

- [ ] Firebase project created & configured
- [ ] All API keys valid and active
- [ ] Android signing key created
- [ ] APK tested on real device
- [ ] Web app tested on Chrome/Edge/Firefox
- [ ] All permissions in AndroidManifest.xml (✅ Already done)
- [ ] Web manifest.json updated (✅ Already done)
- [ ] App icon created and set
- [ ] Screenshots ready for store
- [ ] Privacy policy written
- [ ] Terms of service ready
- [ ] App description cleaned up
- [ ] Version number updated (pubspec.yaml)
- [ ] Build number incremented

### Before Going Live

- [ ] Internal testing passed
- [ ] Beta testing on 10+ users
- [ ] Performance tested (< 200 MB APK)
- [ ] All links working
- [ ] Help/Support page ready
- [ ] Crash reporting enabled (Sentry.io)
- [ ] Analytics configured (Firebase)
- [ ] No security warnings
- [ ] HTTPS enabled on web (automatic)
- [ ] SSL certificate valid

---

## 🚀 Launch Steps

### Phase 1: Soft Launch (Week 1)
```
- Release to internal testing
- Gather feedback
- Fix critical bugs
- Optimize performance
```

### Phase 2: Beta (Week 2)
```
- Expand to 100 beta testers
- Monitor crashes
- Collect feature requests
- Improve UI/UX
```

### Phase 3: Production (Week 3)
```
- Release to all users
- Monitor performance
- Respond to reviews
- Plan updates
```

---

## 📈 Post-Launch

### Monitor Performance

```bash
# Firebase Analytics
- Daily active users
- Session length
- Feature usage

# Crash Reporting
- Sentry.io integration
- Error tracking
- Attribution

# User Feedback
- Play Store reviews
- In-app feedback form
- Social media monitoring
```

### Regular Updates

```bash
# Update cycle
- Bug fixes: Weekly
- Features: Monthly
- Major updates: Quarterly

# Version numbering (MAJOR.MINOR.PATCH+BUILD)
1.0.0+1  → 1.0.1+2    (patch)
1.0.1+2  → 1.1.0+3    (feature)
1.1.0+3  → 2.0.0+4    (major)
```

---

## 🆘 Troubleshooting

### APK Build Fails
```bash
# Common fix
flutter clean
flutter pub get
flutter build apk --release -v

# Check gradle version
cat android/gradle/wrapper/gradle-wrapper.properties
```

### Firebase Connection Error
```bash
# Verify Firebase config
cat lib/firebase_options.dart

# Test connection
flutter pub get
flutter build apk --release
```

### Web Deployment Fails
```bash
# Check build output
flutter build web --release --web-verbose

# Firebase authentication issue
firebase login

# Reinitialization
rm .firebaserc firebase.json
firebase init
```

### App Crashes on Android
```bash
# Check logs
flutter run -v

# Adb logs
adb logcat | grep Flutter

# Common causes
- Missing permissions
- Firebase not initialized
- Invalid API keys
- Storage access denied
```

---

## 📞 Support Resources

### Official Documentation
- [Flutter Deployment](https://flutter.dev/docs/deployment)
- [Firebase Console](https://console.firebase.google.com)
- [Play Store Console](https://play.google.com/apps/publish)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

### Community Help
- Stack Overflow: `flutter` tag
- Reddit: r/FlutterDev
- GitHub Issues: Official Flutter repo
- Discord: Flutter community

---

## ✅ Final Verification

Before launching, verify:

```bash
# 1. All files present
ls -la lib/firebase_options.dart
ls -la android/app/google-services.json  
ls -la web/manifest.json

# 2. Build succeeds
flutter clean
flutter pub get
flutter build apk --release
flutter build web --release

# 3. App runs
flutter run

# 4. Web deployed
firebase deploy --only hosting
```

---

## 🎉 You're Ready!

Once deployed:
1. **Android**: Available on Play Store
2. **Web**: Live at firebase.web.app
3. **Share**: Send links to users
4. **Celebrate**: You built a production app! 🚀

---

**Questions? Check SETUP.md or reach out to Flutter community!**

**Good luck with CodeCraft! 🎓**
