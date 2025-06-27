class Content {
  final int? id;
  final String subMenuTitle; // Foreign key (by title) to sub_menus table
  final String content;

  Content({
    this.id,
    required this.subMenuTitle,
    required this.content,
  });

  // Konversi dari objek Content ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subMenuTitle': subMenuTitle,
      'content': content,
    };
  }

  // Konversi dari Map ke objek Content
  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'],
      subMenuTitle: map['subMenuTitle'],
      content: map['content'],
    );
  }
}
