import 'package:flutter/material.dart';
import 'package:tactix/core/constants/app_enums.dart';

class AppColors {
  // Base Palette - Obsidian Liquid Crystal
  static const Color background = Color(0xFF070B14);
  static const Color backgroundElevated = Color(0xFF0C1322);
  static const Color surface = Color(0xFF10192A);
  static const Color surfaceVariant = Color(0xFF16233B);
  static const Color surfaceElevated = Color(0xFF1D2E4D);
  static const Color card = Color(0xFF111C30);

  // Liquid Crystal Frosted Surfaces
  static const Color glassSurface = Color(0x660F1A2E);
  static const Color glassCard = Color(0x75121F38);
  static const Color glassElevated = Color(0x99172744);
  static const Color glassHighlight = Color(0x1A38BDF8);

  // Borders & Specular Crystal Glare
  static const Color border = Color(0xFF1F314D);
  static const Color borderMuted = Color(0xFF162338);
  static const Color borderHighlight = Color(0xFF38BDF8);
  static const Color crystalBorder = Color(0x3338BDF8);
  static const Color crystalSpecular = Color(0x40FFFFFF);

  // Radiant Crystal Accents
  static const Color amber = Color(0xFFFFB020);
  static const Color cyan = Color(0xFF00E5FF);
  static const Color emerald = Color(0xFF00E676);
  static const Color crimson = Color(0xFFFF3366);
  static const Color violet = Color(0xFFB388FF);
  static const Color orange = Color(0xFFFF7043);
  static const Color blue = Color(0xFF38BDF8);

  // Text Colors (High Accessibility & Contrast)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textInverse = Color(0xFF070B14);

  // Degradation Status Colors
  static const Color statusNormal = Color(0xFF00E676);
  static const Color statusDelayed = Color(0xFFFFB020);
  static const Color statusMissing = Color(0xFFFF3366);
  static const Color statusConflicting = Color(0xFFB388FF);
  static const Color statusPartial = Color(0xFF38BDF8);
  static const Color statusUnverified = Color(0xFFFF7043);
  static const Color statusOffline = Color(0xFF64748B);

  // Difficulty Colors
  static const Color diffBeginner = Color(0xFF00E676);
  static const Color diffIntermediate = Color(0xFFFFB020);
  static const Color diffAdvanced = Color(0xFFFF3366);

  static Color getStatusColor(DegradationType type) {
    switch (type) {
      case DegradationType.normal:
        return statusNormal;
      case DegradationType.delayed:
        return statusDelayed;
      case DegradationType.missing:
        return statusMissing;
      case DegradationType.conflicting:
        return statusConflicting;
      case DegradationType.partial:
        return statusPartial;
      case DegradationType.unverified:
        return statusUnverified;
      case DegradationType.offline:
        return statusOffline;
    }
  }

  static Color getDifficultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.beginner:
        return diffBeginner;
      case DifficultyLevel.intermediate:
        return diffIntermediate;
      case DifficultyLevel.advanced:
        return diffAdvanced;
    }
  }
}

