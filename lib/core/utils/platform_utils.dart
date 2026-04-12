import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformUtils {
  static bool get isWeb => kIsWeb;

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;

  static double get maxWidth => kIsWeb ? 480 : double.infinity;

  static Widget wrapForWeb(Widget child) {
    if (!kIsWeb) return child;
    return Center(
      child: SizedBox(
        width: 480,
        child: ClipRect(child: child),
      ),
    );
  }
}
