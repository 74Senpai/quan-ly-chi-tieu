import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0053DB)),
    scaffoldBackgroundColor: const Color(0xFFFAF8FF),
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(),
  );
}
