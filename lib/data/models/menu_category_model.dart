import 'package:fiqah/data/models/sub_menu_model.dart';
import 'package:flutter/material.dart';

class MenuCategory {
  final int? id;
  final String title;
  final int iconCodePoint; // Simpan icon sebagai code point (integer)
  final int startColor; // Simpan warna sebagai integer (ARGB)
  final int endColor; // Simpan warna sebagai integer (ARGB)
  List<SubMenu> subMenus; // List sub-menu

  MenuCategory({
    this.id,
    required this.title,
    required this.iconCodePoint,
    required this.startColor,
    required this.endColor,
    this.subMenus = const [],
  });

  // Konversi IconData ke int
  static int _iconDataToInt(IconData icon) {
    return icon.codePoint;
  }

  // Konversi List<Color> ke dua integer
  static Map<String, int> _gradientToColors(List<Color> gradient) {
    return {
      'start': gradient[0].value,
      'end': gradient[1].value,
    };
  }

  // Konversi dari objek MenuCategory ke Map (untuk dimasukkan ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconCodePoint': iconCodePoint,
      'startColor': startColor,
      'endColor': endColor,
    };
  }

  // Konversi dari Map (dari DB) ke objek MenuCategory
  factory MenuCategory.fromMap(Map<String, dynamic> map) {
    return MenuCategory(
      id: map['id'],
      title: map['title'],
      iconCodePoint: map['iconCodePoint'],
      startColor: map['startColor'],
      endColor: map['endColor'],
      subMenus: [], // Submenu akan diisi secara terpisah
    );
  }

  // Helper untuk mendapatkan IconData kembali
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  // Helper untuk mendapatkan gradient kembali
  List<Color> get gradient => [Color(startColor), Color(endColor)];
}
