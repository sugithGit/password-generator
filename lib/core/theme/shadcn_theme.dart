import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShadcnTheme {
  static const Color accentColor = Color(0xFF6C63FF);

  static ThemeData get darkTheme {
    const ColorScheme colorScheme = ColorScheme.dark(
      background: Color(0xFF09090B),
      onBackground: Color(0xFFFAFAFA),
      surface: Color(0xFF09090B),
      onSurface: Color(0xFFFAFAFA),
      surfaceVariant: Color(0xFF18181B), // Used for cards/containers
      onSurfaceVariant: Color(0xFFA1A1AA), // Muted text
      primary: accentColor,
      onPrimary: Colors.white,
      secondary: Color(0xFF27272A),
      onSecondary: Color(0xFFFAFAFA),
      outline: Color(0xFF27272A),
      error: Color(0xFFEF4444),
      onError: Colors.white,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData get lightTheme {
    const ColorScheme colorScheme = ColorScheme.light(
      background: Color(0xFFFFFFFF),
      onBackground: Color(0xFF09090B),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF09090B),
      surfaceVariant: Color(0xFFF4F4F5), // Used for cards/containers
      onSurfaceVariant: Color(0xFF71717A), // Muted text
      primary: accentColor,
      onPrimary: Colors.white,
      secondary: Color(0xFFE4E4E7),
      onSecondary: Color(0xFF18181B),
      outline: Color(0xFFE4E4E7),
      error: Color(0xFFEF4444),
      onError: Colors.white,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseTextTheme = GoogleFonts.monaSansTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    final textTheme = baseTextTheme.copyWith(
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 16,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
        fontSize: 14,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w800,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      cardColor: colorScheme.surfaceVariant,
      dividerColor: colorScheme.outline,
      fontFamily: GoogleFonts.monaSans().fontFamily,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withAlpha(150), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(
          color: colorScheme.outline,
          width: 1.5,
        ),
      ),
    );
  }
}
