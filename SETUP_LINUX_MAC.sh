#!/bin/bash

echo "============================================"
echo "CodeCraft App - Setup & Fix Script"
echo "============================================"

echo ""
echo "[1/5] Installing flutterfire_cli..."
dart pub global activate flutterfire_cli
if [ $? -ne 0 ]; then
    echo "Error installing flutterfire_cli"
    exit 1
fi

echo ""
echo "[2/5] Cleaning Flutter..."
flutter clean
if [ $? -ne 0 ]; then
    echo "Error cleaning Flutter"
    exit 1
fi

echo ""
echo "[3/5] Getting dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "Error getting dependencies"
    exit 1
fi

echo ""
echo "[4/5] Running build_runner..."
dart run build_runner build --delete-conflicting-outputs
if [ $? -ne 0 ]; then
    echo "Warning: build_runner had issues (this is usually ok)"
fi

echo ""
echo "[5/5] Setup complete!"
echo ""
echo "============================================"
echo "NEXT STEPS:"
echo "============================================"
echo ""
echo "1. Configure Firebase:"
echo "   flutterfire configure"
echo ""
echo "   (When prompted, select your Firebase project)"
echo ""
echo "2. Run on Chrome:"
echo "   flutter run -d chrome"
echo ""
echo "3. Run on Android:"
echo "   flutter run"
echo ""
echo "============================================"
