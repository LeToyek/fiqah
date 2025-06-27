class SubMenu {
  final int? id;
  final String title;
  final int categoryId; // Foreign Key ke tabel categories

  SubMenu({
    this.id,
    required this.title,
    required this.categoryId,
  });

  // Konversi dari objek SubMenu ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
    };
  }

  // Konversi dari Map ke objek SubMenu
  factory SubMenu.fromMap(Map<String, dynamic> map) {
    return SubMenu(
      id: map['id'],
      title: map['title'],
      categoryId: map['categoryId'],
    );
  }
}
