import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Palette (Primary Experience)
  static const Color darkBackground = Color(0xFF090910);
  static const Color darkSurface = Color(0xFF131320);
  static const Color darkSurfaceElevated = Color(0xFF1B1B2C);
  static const Color darkCard = Color(0xFF1E1E30);
  static const Color darkGlass = Color(0x2820203A);
  static const Color darkGlassBorder = Color(0x35FFFFFF);

  // Vibrant Accents & Brand Spectrum
  static const Color electricViolet = Color(0xFF8B5CF6);
  static const Color deepViolet = Color(0xFF6D28D9);
  static const Color softCyan = Color(0xFF06B6D4);
  static const Color neonCyan = Color(0xFF00F5D4);
  static const Color cyberMagenta = Color(0xFFEC4899);
  static const Color warmPink = Color(0xFFF43F5E);
  static const Color radiantAmber = Color(0xFFF59E0B);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricViolet, cyberMagenta],
  );

  static const LinearGradient cyanVioletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonCyan, electricViolet],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C1C2E), Color(0xFF12121E)],
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x35FFFFFF), Color(0x0DFFFFFF)],
  );

  static const RadialGradient glowGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [Color(0x408B5CF6), Colors.transparent],
  );

  // Dark Theme Text & Monochromes
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C8);
  static const Color textMuted = Color(0xFF70708C);
  static const Color borderSubtle = Color(0xFF28283E);

  // Light Palette Alternative
  static const Color lightBackground = Color(0xFFF8F9FE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFEFF1FA);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightGlass = Color(0xCCFFFFFF);
  static const Color lightGlassBorder = Color(0x20000000);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightBorder = Color(0xFFE2E8F0);
}
