import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds - Matte Dark
  static const Color background = Color(0xFF121212); // Matte Black
  static const Color cardBackground = Color(0xFF1E1E1E); // Dark Slate
  static const Color cardBackgroundAlt = Color(0xFF252525); // Slightly lighter
  static const Color darkBackground = Color(0xFF000000); // Pure Black

  // Primary Colors (Deep & Vibrant for White Text)
  static const Color primary = Color(0xFF5E35B1); // Deep Purple 600
  static const Color primaryDark = Color(0xFF4527A0); // Deep Purple 800
  static const Color primaryLight = Color(0xFF9575CD); // Deep Purple 300

  // Accent Colors (Muted for Contrast)
  static const Color accent = Color(0xFF3949AB); // Indigo 600
  static const Color accentSecondary = Color(0xFFD81B60); // Pink 600
  static const Color accentTertiary = Color(0xFF8E24AA); // Purple 600
  static const Color accentYellow = Color(0xFFFFB300); // Amber 600 (Readable)

  // Secondary Colors
  static const Color secondary = Color(0xFF00897B); // Teal 600
  static const Color secondaryDark = Color(0xFF00695C); // Teal 800
  static const Color secondaryLight = Color(0xFF4DB6AC); // Teal 400

  // Gradients (Subtle Dark)
  static const Color gradientStart = Color(0xFF5C6BC0); // Indigo 400
  static const Color gradientMid = Color(0xFF7E57C2); // Deep Purple 400
  static const Color gradientEnd = Color(0xFFAB47BC); // Purple 400

  // Neon (Mapped to Muted)
  static const Color neonCyan = Color(0xFF26C6DA);
  static const Color neonPurple = Color(0xFF7E57C2);
  static const Color neonPink = Color(0xFFEC407A);

  // Text (Inverted for Dark Mode)
  static const Color textDark = Color(0xFFEEEEEE); // White (Primary)
  static const Color textLight = Color(0xFFB0BEC5); // Light Grey
  static const Color textMedium = Color(0xFF90A4AE); // Blue Grey
  static const Color textOnDark = Colors.white; // White

  // Status (Softened)
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);

  // Glass/Translucent effects
  static Color glass = Colors.white.withValues(alpha: 0.05);
  static Color glassBorder = Colors.white.withValues(alpha: 0.1);
}

extension ColorExtension on Color {
  Color get shade700 {
    // Create a darker shade
    return Color.lerp(this, Colors.black, 0.3) ?? this;
  }
}
