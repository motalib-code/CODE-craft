# CodeCraft - Troubleshooting & Fixes

## 🔧 Issues Fixed

### 1. **GradientButton Parameter Error** ✅ FIXED
**Error**: `No named parameter with the name 'text'`

**Cause**: Using `text:` instead of `label:` parameter

**Fix Applied**:
```dart
// Before ❌
GradientButton(
  text: 'Generate Roadmap',  // WRONG
  onPressed: _parse,         // WRONG
)

// After ✅
GradientButton(
  label: 'Generate Roadmap',  // CORRECT
  onTap: _parse,              // CORRECT
)
```

**Files Fixed**:
- `lib/features/roadmap/screens/syllabus_parser_screen.dart`

---

### 2. **Const Text with Dynamic Styles** ✅ FIXED
**Error**: `Constant evaluation error` - Can't use `const Text` with non-constant styles

**Cause**: `const Text(style: AppTextStyles.h2)` where `AppTextStyles.h2` is not a compile-time constant

**Fix Applied**:
```dart
// Before ❌
const Text(
  'Upload or Paste your Syllabus 📄',
  style: AppTextStyles.h2,  // Not constant!
)

// After ✅
Text(
  'Upload or Paste your Syllabus 📄',
  style: AppTextStyles.h2,
)
```

**Files Fixed**:
- `lib/features/roadmap/screens/syllabus_parser_screen.dart` (lines 64, 72)

---

### 3. **Missing flutterfire CLI** ✅ FIX PROVIDED
**Error**: `flutterfire : The term 'flutterfire' is not recognized`

**Cause**: flutterfire_cli not installed globally

**Fix**:
```bash
# Install flutterfire CLI
dart pub global activate flutterfire_cli

# OR use flutter wrapper
flutter pub global activate flutterfire_cli

# Then configure
flutterfire configure
```

**Windows Users**: 
- Use `SETUP_WINDOWS.bat` (created in repo root)
- Or run commands in PowerShell

---

## 🚀 Complete Setup Instructions

### Step 1: Clean Installation
```bash
cd c:\Users\91720\gecwp\student_app

# Clean everything
flutter clean

# Get dependencies
flutter pub get
```

### Step 2: Install flutterfire CLI
```bash
# For Windows PowerShell
dart pub global activate flutterfire_cli

# Verify installation
flutterfire --version
```

### Step 3: Configure Firebase
```bash
flutterfire configure

# Follow prompts:
# 1. Select existing project OR create new one
# 2. Choose platforms: Android, Web
# 3. Wait for configuration
```

This auto-generates:
- `lib/firebase_options.dart` - Firebase configuration
- Updates build.gradle files
- Updates web configuration

### Step 4: Run Build Runner (Optional)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 5: Test on Chrome
```bash
flutter run -d chrome
```

### Step 6: Test on Android
```bash
flutter run
```

---

## 🛠️ Common Commands

### Install Tools
```bash
# flutterfire CLI
dart pub global activate flutterfire_cli

# flutter_lints
dart pub global activate flutter_lints
```

### Update Dependencies
```bash
flutter pub upgrade
flutter pub outdated
```

### Clean & Rebuild
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run on Specific Device
```bash
flutter devices                    # List devices
flutter run -d <device-id>        # Run on device
flutter run -d chrome              # Chrome
flutter run -d edge                # Edge
flutter run -d android             # Android device
```

---

## ⚠️ Known Issues & Solutions

### Issue: Build Fails with "Nothing to build"
```bash
# This is normal - means no Freezed models to generate
# It's not an error
```

### Issue: Firebase not initialized on first run
```bash
# Make sure you ran flutterfire configure
flutterfire configure
```

### Issue: Package is discontinued (flutter_markdown)
```bash
# This is a warning, not an error
# To fix: Update to flutter_markdown_plus
# For now: It works fine as-is
```

### Issue: Deprecated build_runner warning
```bash
# Use new command instead
dart run build_runner build --delete-conflicting-outputs
# Instead of deprecated:
flutter pub run build_runner build
```

---

## 📱 Running on Different Platforms

### Android Phone
```bash
# 1. Connect phone with USB debugging enabled
adb devices

# 2. Run app
flutter run

# 3. Select device if multiple connected
flutter run -d <device-id>
```

### Chrome Browser
```bash
flutter run -d chrome

# App opens at: http://localhost:8080
```

### Edge Browser
```bash
flutter run -d edge
```

### Firefox Browser
```bash
flutter run -d firefox
```

### All Browsers Simultaneously
```bash
# Terminal 1
flutter run -d chrome

# Terminal 2
flutter run -d edge

# Terminal 3
flutter run -d firefox
```

---

## 🔍 Debugging Tips

### View Verbose Logs
```bash
flutter run -v

# Output: Detailed compilation & runtime logs
```

### Check Adb Logs (Android)
```bash
adb logcat | grep Flutter
```

### Check Browser Console (Web)
```
1. Press F12 in browser
2. Go to Console tab
3. Look for errors (red text)
```

### Profile Performance
```bash
flutter run --profile
```

### Check Device Connections
```bash
flutter devices
adb devices
```

---

## 📦 Dependency Status

### Packages with Available Updates
Some packages have newer versions available. To update (optional):

```bash
# Check which are outdated
flutter pub outdated

# Update all safely
flutter pub upgrade --major-versions

# Or selectively update specific package
flutter pub upgrade google_fonts
```

### Packages to Watch
- ✅ `flutter_riverpod` - Working fine on 2.6.1
- ✅ `firebase_core` - Working fine on 3.15.2
- ⚠️ `flutter_markdown` - Discontinued but still works
- ✅ `go_router` - Working fine on 13.2.5

---

## ✅ Verification Checklist

After setup, verify everything works:

```bash
# 1. Dependencies installed
flutter pub get

# 2. Build succeeds
flutter build apk --debug
flutter build web --debug

# 3. App runs
flutter run -d chrome
# OR
flutter run (Android)

# 4. Features work
# - [ ] Login/Signup
# - [ ] Navigate between tabs
# - [ ] AI chat responds
# - [ ] Code editor works
# - [ ] Problems load

# 5. Check logs
flutter run -v 2>&1 | grep -i error
```

---

## 🆘 If Still Having Issues

### Completely Fresh Start
```bash
# Remove all generated files
flutter clean
rm -r .dart_tool
rm pubspec.lock

# Fresh install
flutter pub get
flutterfire configure

# Run
flutter run -d chrome
```

### Windows-Specific
```powershell
# Use this batch file
.\SETUP_WINDOWS.bat

# Or manually in PowerShell
flutter clean
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure
flutter run -d chrome
```

### Linux/Mac
```bash
# Use this shell script
chmod +x SETUP_LINUX_MAC.sh
./SETUP_LINUX_MAC.sh

# Or manually
flutter clean
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure
flutter run -d chrome
```

---

## 📞 Additional Resources

- [Flutter Troubleshooting](https://flutter.dev/docs/testing/troubleshooting)
- [Firebase Setup](https://firebase.flutter.dev)
- [GoRouter Navigation](https://pub.dev/packages/go_router)
- [Riverpod State Management](https://riverpod.dev)

---

## ✨ Summary of Fixes

| Issue | Status | Fix |
|-------|--------|-----|
| GradientButton parameter | ✅ Fixed | Changed `text:` to `label:`, `onPressed:` to `onTap:` |
| Const Text with styles | ✅ Fixed | Removed `const` keyword |
| flutterfire CLI not found | ✅ Solution | Install with `dart pub global activate flutterfire_cli` |
| Build runner warning | ✅ Normal | Use `dart run` instead (optional) |
| flutter_markdown deprecated | ⚠️ Works | Not critical, can upgrade if needed |

---

**App is now ready to run! 🚀**

Next step: `flutter run -d chrome` or `flutter run`
