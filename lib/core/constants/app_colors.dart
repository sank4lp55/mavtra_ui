// lib/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Core theme colors
  static const Color primary = Color(0xFFEAB308); // Golden Yellow
  static const Color background = Color(0xFF0B0F19); // Darker Blue-Grey
  static const Color surface = Color(0xFFF9FAFB); // Light Surface
  static const Color accent = Color(0xFF6366F1); // Indigo

  // Basic colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Neutrals
  static const Color grey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFE5E7EB);

// Module colors (Rainbow palette)
  static const List<Color> moduleColors = [
    const Color(0xFF4F46E5), // Sale Orders
    const Color(0xFF059669), // Purchase
    const Color(0xFFED495E), // Gate Activity
    const Color(0xFF7C3AED), // Shipping
    const Color(0xFFDC2626), // Reports
    const Color(0xFF0891B2), // Sanding
    const Color(0xFFDB2777), // Polish
  ];
}
