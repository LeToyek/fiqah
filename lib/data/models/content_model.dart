// file: lib/data/models/content_model.dart

class Content {
  final int? id;
  final String subMenuTitle;
  final String content;
  final String? reference; // Properti untuk menyimpan referensi

  Content({
    this.id,
    required this.subMenuTitle,
    required this.content,
    this.reference, // Tambahkan di constructor
  });

  // Konversi dari Map (dari DB) ke objek Content
  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'],
      subMenuTitle: map['subMenuTitle'],
      content: map['content'],
      reference: map['reference'], // Baca data referensi dari map
    );
  }

  // Konversi dari objek Content ke Map (untuk dimasukkan ke DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subMenuTitle': subMenuTitle,
      'content': content,
      'reference': reference, // Tulis data referensi ke map
    };
  }
}
