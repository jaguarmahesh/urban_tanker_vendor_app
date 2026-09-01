import 'package:flutter/material.dart';

class AppTheme {
  // Colors - Exact match to dashboard design
  static const Color primary = Color(0xFF2563eb);           // Blue
  static const Color primaryLight = Color(0xFFEAF2FF);      // Light blue
  static const Color secondary = Color(0xFF7655D6);         // Purple
  static const Color success = Color(0xFF159447);           // Green
  static const Color successLight = Color(0xFFE9F8EF);      // Light green
  static const Color warning = Color(0xFFD97706);           // Orange
  static const Color warningLight = Color(0xFFFFF5DF);      // Light orange
  static const Color danger = Color(0xFFD92D3B);            // Red
  static const Color dangerLight = Color(0xFFFFF0F1);       // Light red

  // Neutral Colors
  static const Color background = Color(0xFFF5F7FB);        // Light blue-gray
  static const Color surface = Color(0xFFFFFFFF);           // White
  static const Color text = Color(0xFF20252B);              // Dark text
  static const Color textMuted = Color(0xFF6F7883);         // Gray text
  static const Color border = Color(0xFFE4E8ED);            // Light gray border
  static const Color divider = Color(0xFFEEF1F4);           // Divider color

  // Shadow
  static const BoxShadow shadowSm = BoxShadow(
    color: Color(0x1A1D2B3A),
    blurRadius: 4,
    offset: Offset(0, 1),
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color(0x1A1D2B3A),
    blurRadius: 9,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x1A1D2B3A),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  // Font Sizes
  static const double fontXs = 10.0;
  static const double fontSm = 11.0;
  static const double fontBase = 13.0;
  static const double fontMd = 14.0;
  static const double fontLg = 16.0;
  static const double fontXl = 18.0;
  static const double font2xl = 25.0;
  static const double font3xl = 28.0;

  // Font Weights
  static const FontWeight fw400 = FontWeight.w400;  // Normal
  static const FontWeight fw500 = FontWeight.w500;  // Medium
  static const FontWeight fw600 = FontWeight.w600;  // SemiBold
  static const FontWeight fw700 = FontWeight.w700;  // Bold
  static const FontWeight fw800 = FontWeight.w800;  // ExtraBold

  // Spacing
  static const double spacing1 = 4.0;   // xs
  static const double spacing2 = 8.0;   // sm
  static const double spacing3 = 12.0;  // md
  static const double spacing4 = 16.0;  // lg
  static const double spacing5 = 20.0;  // xl
  static const double spacing6 = 24.0;  // 2xl
  static const double spacing7 = 28.0;  // 3xl
  static const double spacing8 = 32.0;  // 4xl

  // Border Radius
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 10.0;
  static const double radiusFull = 99.0;

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: text,
      ),
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: text,
          fontSize: fontLg,
          fontWeight: fw700,
          fontFamily: 'Poppins',
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing4,
          vertical: spacing3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: danger),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: fontBase),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: fontBase,
            fontWeight: fw700,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(
            horizontal: spacing4,
            vertical: spacing3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontSize: fontBase,
            fontWeight: fw700,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: font3xl,
        fontWeight: fw800,
        color: text,
      ),
      displayMedium: TextStyle(
        fontSize: font2xl,
        fontWeight: fw700,
        color: text,
      ),
      headlineSmall: TextStyle(
        fontSize: fontXl,
        fontWeight: fw700,
        color: text,
      ),
      titleLarge: TextStyle(
        fontSize: fontLg,
        fontWeight: fw700,
        color: text,
      ),
      titleMedium: TextStyle(
        fontSize: fontMd,
        fontWeight: fw600,
        color: text,
      ),
      titleSmall: TextStyle(
        fontSize: fontBase,
        fontWeight: fw600,
        color: text,
      ),
      bodyLarge: TextStyle(
        fontSize: fontBase,
        fontWeight: fw400,
        color: text,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSm,
        fontWeight: fw400,
        color: text,
      ),
      bodySmall: TextStyle(
        fontSize: fontXs,
        fontWeight: fw400,
        color: textMuted,
      ),
      labelLarge: TextStyle(
        fontSize: fontBase,
        fontWeight: fw600,
        color: text,
      ),
    );
  }
}
