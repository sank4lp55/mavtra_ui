// lib/widgets/menu_box.dart
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/app_colors.dart';

class MenuBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;
  final double? height;
  final double? width;

  const MenuBox({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 80,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: _getIconColor(),
              size: 28,
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getIconColor() {
    if (backgroundColor == const Color(0xFF90EE90)) { // Light green
      return AppColors.black;
    } else if (backgroundColor == AppColors.primary) {
      return AppColors.black;
    } else if (backgroundColor == AppColors.accent) {
      return AppColors.white;
    } else {
      return AppColors.black;
    }
  }

  Color _getTextColor() {
    if (backgroundColor == const Color(0xFF90EE90)) { // Light green
      return AppColors.black;
    } else if (backgroundColor == AppColors.primary) {
      return AppColors.black;
    } else if (backgroundColor == AppColors.accent) {
      return AppColors.white;
    } else {
      return AppColors.black;
    }
  }
}