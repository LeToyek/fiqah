import 'package:flutter/material.dart';

class MenuCategory {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final List<String> subMenus;

  MenuCategory({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.subMenus,
  });
}
