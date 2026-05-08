import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF10B981); // Bright Teal/Green
  static const Color darkBlue = Color(0xFF1E293B); // Dark slate/blue for text
  static const Color background = Color(0xFFF1F5F9); // Light gray/blue bg
  static const Color primaryBlue = Color(0xFF2563EB); // Blue for cards
  static const Color white = Colors.white;
  static const Color lightGreen = Color(0xFF6EE7B7);
  static const Color textGray = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: darkBlue, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: darkBlue, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(color: darkBlue),
        bodyMedium: GoogleFonts.inter(color: textGray),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryBlue,
        background: background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
