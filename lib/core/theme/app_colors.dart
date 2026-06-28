import 'package:flutter/material.dart';

abstract final class AppColors {
  // Supabase Green Glowing Theme
  static const Color background = Color(0xFF0A0A0A); // Deep dark background
  static const Color foreground = Color(
    0xFFFAFAFA,
  ); // Off-white for readability
  static const Color card = Color(0x0CFFFFFF); // Translucent for glassmorphism
  static const Color cardVariant = Color(
    0x14FFFFFF,
  ); // Slightly lighter translucent

  static const Color primary = Color(0xFF3ECF8E); // Supabase Green
  static const Color deepTeal = Color(0xFF3ECF8E); // Supabase Green
  static const Color onPrimary = Color(
    0xFF0A0A0A,
  ); // High contrast text on green

  static const Color secondary = Color(
    0xFF1E293B,
  ); // Slate 800 - dark subtle accent
  static const Color onSecondary = Color(0xFFFAFAFA);

  static const Color muted = Color(0xFF27272A);
  static const Color mutedForeground = Color(0xFFA1A1AA);

  static const Color border = Color(
    0x1AFFFFFF,
  ); // Very subtle thin border for glass effect

  static const Color error = Color(0xFFEF4444);
  static const Color onError = Colors.white;

  static const textSecondary = Color(0xFFA1A1AA);
  static const textDisabled = Color(0xFF52525B);
  static const textPrimary = Color(0xFFFFFFFF);

  // Custom glowing accents
  static const glowGreen = Color(0x333ECF8E);
}
