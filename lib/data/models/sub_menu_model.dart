// file: lib/data/models/sub_menu_model.dart

import 'package:fiqah/data/models/content_model.dart';

class SubMenu {
  final int? id;
  final String title;
  final int categoryId;
  Content? content; // Tambahkan ini untuk menampung konten terkait

  SubMenu({
    this.id,
    required this.title,
    required this.categoryId,
    this.content,
  });

  // Konversi dari Map (dari DB) ke objek SubMenu
  factory SubMenu.fromMap(Map<String, dynamic> map) {
    return SubMenu(
      id: map['id'],
      title: map['title'],
      categoryId: map['categoryId'],
    );
  }

  // Konversi dari objek SubMenu ke Map (untuk dimasukkan ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
    };
  }
}
