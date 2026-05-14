import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8C85A);
  static const Color goldDark = Color(0xFFB8941F);
  static const Color background = Color(0xFF0a0a0a);
  static const Color card = Color(0xFF121212);
  static const Color secondary = Color(0xFF1e1e1e);
  static const Color foreground = Color(0xFFE3E0D8); // hsl(43 30% 90%)
  static const Color mutedForeground = Color(0xFF8C8C8C); // hsl(0 0% 55%)
  static const Color border = Color(0xFF332F26); // hsl(43 20% 20%)
  static const Color input = Color(0xFF262626);

  static LinearGradient get goldGradient => const LinearGradient(
        colors: [gold, goldLight, goldDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static List<BoxShadow> get premiumShadow => [
        BoxShadow(
          color: gold.withOpacity(0.1),
          blurRadius: 30,
          offset: const Offset(0, 15),
          spreadRadius: -5,
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: gold.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: gold,
      scaffoldBackgroundColor: background,
      cardColor: card,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        secondary: secondary,
        surface: card,
        onPrimary: Colors.black,
        onSecondary: foreground,
        onSurface: foreground,
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 36.sp,
          fontWeight: FontWeight.w700,
          color: foreground,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 28.sp,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          color: gold,
          letterSpacing: 1.5,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.sp,
          color: foreground,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.sp,
          color: foreground.withOpacity(0.8),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12.sp,
          color: mutedForeground,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: mutedForeground,
          letterSpacing: 2.5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          padding: EdgeInsets.symmetric(vertical: 18.h),
          textStyle: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground.withOpacity(0.8),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          padding: EdgeInsets.symmetric(vertical: 18.h),
          textStyle: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: gold, width: 1),
        ),
        hintStyle: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.2),
          fontSize: 14.sp,
        ),
        labelStyle: GoogleFonts.inter(
          color: gold,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 3,
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: gold,
        unselectedItemColor: mutedForeground,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
