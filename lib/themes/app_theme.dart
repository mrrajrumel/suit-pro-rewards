import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color gold = const Color(0xFFD4AF37);
  static final Color background = const Color(0xFF0a0a0a);
  static final Color card = const Color(0xFF121212);
  static final Color foreground = const Color(0xFFE3E0D8); // hsl(43 30% 90%)
  static final Color mutedForeground = const Color(0xFF8C8C8C); // hsl(0 0% 55%)
  static final Color border = const Color(0xFF4D4533); // hsl(43 20% 20%)

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: gold,
      scaffoldBackgroundColor: background,
      cardColor: card,
      
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(fontSize: 48, fontWeight: FontWeight.bold, color: foreground),
        headlineMedium: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: foreground),
        headlineSmall: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, color: foreground),
        titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: foreground),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: foreground),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: mutedForeground),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: mutedForeground),
        labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border),
        ),
        hintStyle: TextStyle(color: mutedForeground),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: gold,
        unselectedItemColor: mutedForeground,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
