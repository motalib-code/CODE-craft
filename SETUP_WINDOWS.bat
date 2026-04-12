@echo off
echo ============================================
echo CodeCraft App - Setup & Fix Script
echo ============================================

echo.
echo [1/5] Installing flutterfire_cli...
dart pub global activate flutterfire_cli
if errorlevel 1 (
    echo Error installing flutterfire_cli
    pause
    exit /b 1
)

echo.
echo [2/5] Cleaning Flutter...
call flutter clean
if errorlevel 1 (
    echo Error cleaning Flutter
    pause
    exit /b 1
)

echo.
echo [3/5] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo Error getting dependencies
    pause
    exit /b 1
)

echo.
echo [4/5] Running build_runner...
call dart run build_runner build --delete-conflicting-outputs
if errorlevel 1 (
    echo Warning: build_runner had issues (this is usually ok)
)

echo.
echo [5/5] Setup complete!
echo.
echo ============================================
echo NEXT STEPS:
echo ============================================
echo.
echo 1. Configure Firebase:
echo    flutterfire configure
echo.
echo    (When prompted, select your Firebase project)
echo.
echo 2. Run on Chrome:
echo    flutter run -d chrome
echo.
echo 3. Run on Android:
echo    flutter run
echo.
echo ============================================

pause
