import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/squircle.dart';
import 'app_colors.dart';

class ShadcnTheme {
  static const Color accentColor = AppColors.background;

  static ThemeData get darkTheme {
    const ColorScheme colorScheme = ColorScheme.dark(
      surface: AppColors.background,
      onSurface: AppColors.foreground,
      surfaceContainerHighest: AppColors.cardVariant,
      onSurfaceVariant: AppColors.mutedForeground,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      outline: AppColors.border,
      error: AppColors.error,
      onError: AppColors.onError,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final TextTheme baseTextTheme = GoogleFonts.outfitTextTheme(
      ThemeData.dark().textTheme,
    );

    final TextTheme textTheme = baseTextTheme.copyWith(
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
        letterSpacing: -0.5,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: -0.5,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surfaceContainerHighest,
      dividerColor: colorScheme.outline,
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: textTheme,
      // Glassmorphic Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        shape: const Squircle(
          radius: 24,
        ).shape(side: BorderSide(color: colorScheme.outline)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge,
      ),
      // Glassmorphic Pill-Shaped Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          fontSize: 14,
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2), // Pill shape
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      // Pill-Shaped Glowing Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4, // Slight elevation for glow effect shadow
          shadowColor: colorScheme.primary.withOpacity(0.5),
          minimumSize: const Size.fromHeight(56),
          shape: const Squircle(radius: 100).outlinedShape(),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
      ),
    );
  }
}
