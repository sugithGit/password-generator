import 'package:flutter/material.dart';

abstract final class AppColors {
  // Pure Dark Shadcn (Zinc Palette)
  static const Color background = Color(0xFF09090B);      // Zinc 950
  static const Color foreground = Color(0xFFFAFAFA);      // Zinc 50
  static const Color card = Color(0xFF09090B);            // Zinc 950 (or zinc-950/900 mix)
  static const Color cardVariant = Color(0xFF18181B);     // Zinc 900
  static const Color primary = Color(0xFFFAFAFA);         // Zinc 50
  static const Color onPrimary = Color(0xFF09090B);       // Zinc 950
  static const Color secondary = Color(0xFF27272A);       // Zinc 800
  static const Color onSecondary = Color(0xFFFAFAFA);     // Zinc 50
  static const Color muted = Color(0xFF27272A);           // Zinc 800
  static const Color mutedForeground = Color(0xFFA1A1AA);  // Zinc 400
  static const Color border = Color(0xFF27272A);          // Zinc 800
  static const Color error = Color(0xFFEF4444);           // Red 500
  static const Color onError = Colors.white;
}
