import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────
  static const Color bg = Color(0xFF1A1033);
  static const Color bgCard = Color(0xFF13111E);
  static const Color bgSurface = Color(0xFF1A1730);
  static const Color bgInput = Color(0xFF1E1B35);

  // ── Brand ────────────────────────────────────────
  static const Color purple = Color(0xFF6B5CE7);
  static const Color blue = Color(0xFF2563EB);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color green = Color(0xFF10B981);
  static const Color mint = Color(0xFF6EE7B7);
  static const Color pink = Color(0xFFEC4899);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
  static const Color gold = Color(0xFFFFC107);

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF8F8FF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF475569);

  // ── Border ───────────────────────────────────────
  static const Color border = Color(0x14FFFFFF);
  static const Color borderPurple = Color(0x667C3AED);

  // ── Gradients ────────────────────────────────────
  static const LinearGradient gradPurpleBlue = LinearGradient(
    colors: [Color(0xFF6B5CE7), Color(0xFF4A3E99)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradBlueCyan = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
  );

  static const LinearGradient gradGreenBlue = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF2563EB)],
  );

  static const LinearGradient gradGreenMint = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF34D399)],
  );

  static const LinearGradient gradPinkPurple = LinearGradient(
    colors: [Color(0xFFEC4899), Color(0xFF6B5CE7)],
  );

  static const LinearGradient gradBg = LinearGradient(
    colors: [Color(0xFF1A1033), Color(0xFF13111E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
