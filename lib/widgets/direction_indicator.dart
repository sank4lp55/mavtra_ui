
// lib/widgets/direction_indicator.dart
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/app_colors.dart';

class DirectionIndicator extends StatelessWidget {
  final String direction;

  const DirectionIndicator({
    super.key,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_back,
            color: AppColors.black,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            direction,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}