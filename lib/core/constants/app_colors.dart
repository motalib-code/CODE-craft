import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────
  static const Color bg = Color(0xFF0D0B1F);
  static const Color bgCard = Color(0xFF13111E);
  static const Color bgSurface = Color(0xFF1A1730);
  static const Color bgInput = Color(0xFF1E1B35);

  // ── Brand ────────────────────────────────────────
  static const Color purple = Color(0xFF7C3AED);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF10B981);
  static const Color pink = Color(0xFFEC4899);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
  static const Color gold = Color(0xFFFCD34D);

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF8F8FF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF475569);

  // ── Border ───────────────────────────────────────
  static const Color border = Color(0x14FFFFFF);
  static const Color borderPurple = Color(0x667C3AED);

  // ── Gradients ────────────────────────────────────
  static const LinearGradient gradPurpleBlue = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradGreenBlue = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF2563EB)],
  );
  static const LinearGradient gradPinkPurple = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFF7C3AED)],
  );
  static const LinearGradient gradBg = LinearGradient(
    colors: [Color(0xFF0D0B1F), Color(0xFF13111E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient gradOrangeRed = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
  );
}
