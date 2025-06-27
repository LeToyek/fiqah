import 'package:flutter/material.dart';

class ContentScreen extends StatelessWidget {
  final String title;
  final String category;

  const ContentScreen({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kategori: $category',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Konten Materi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    'Materi tentang "$title" akan ditampilkan di sini.\n\n'
                    'Ini adalah tempat di mana konten fiqih pernikahan akan dijelaskan secara detail. '
                    'Anda dapat menambahkan konten yang sesuai dengan setiap topik yang telah didefinisikan.\n\n'
                    'Konten dapat berupa:\n'
                    '• Penjelasan dalil-dalil Al-Quran dan Hadits\n'
                    '• Penjelasan hukum fiqih\n'
                    '• Contoh-contoh praktis\n'
                    '• Tips dan panduan\n\n'
                    'Aplikasi ini dapat dikembangkan lebih lanjut dengan menambahkan database konten yang lebih lengkap.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
