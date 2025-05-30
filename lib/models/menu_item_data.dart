// lib/models/menu_item_data.dart
import 'package:flutter/material.dart';

class MenuItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}