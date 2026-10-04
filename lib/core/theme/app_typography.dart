import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactix/core/theme/app_colors.dart';

class AppTypography {
  // Display & Headers (Tactical / Command Center Style)
  static TextStyle displayLarge = GoogleFonts.rajdhani(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.rajdhani(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.rajdhani(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: AppColors.textPrimary,
  );

  // Headlines
  static TextStyle headlineMedium = GoogleFonts.rajdhani(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.rajdhani(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  // Body Text (Inter for high legibility on mobile screens)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // Monospace Telemetry / Code / Timestamps / Status Codes
  static TextStyle monoLarge = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle monoMedium = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle monoSmall = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
  );

  static TextStyle badge = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}
