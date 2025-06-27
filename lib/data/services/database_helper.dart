import 'package:fiqah/data/models/content_model.dart';
import 'package:fiqah/data/models/menu_category_model.dart';
import 'package:fiqah/data/models/sub_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path =
        join(await getDatabasesPath(), 'fiqah_app_v2.db'); // v2 for new schema
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        iconCodePoint INTEGER NOT NULL,
        startColor INTEGER NOT NULL,
        endColor INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sub_menus(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL UNIQUE,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    // Tabel baru untuk konten
    await db.execute('''
      CREATE TABLE contents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subMenuTitle TEXT NOT NULL UNIQUE,
        content TEXT NOT NULL,
        FOREIGN KEY (subMenuTitle) REFERENCES sub_menus(title) ON DELETE CASCADE
      )
    ''');

    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final List<Map<String, dynamic>> initialCategories = [
      // Data kategori dan sub-menu sama seperti sebelumnya...
      {
        'title': 'Pra Nikah',
        'icon': Icons.psychology,
        'gradient': [Colors.pink[300]!, Colors.pink[500]!],
        'subMenus': [
          'Memilih Pasangan',
          'Khitbah (Peminangan)',
          'Syarat dan Rukun Nikah',
          'Adab Sebelum Menikah',
          'Persiapan Mental dan Spiritual',
        ],
      },
      {
        'title': 'Nikah',
        'icon': Icons.favorite,
        'gradient': [Colors.green[300]!, Colors.green[500]!],
        'subMenus': [
          'Ijab Kabul',
          'Saksi Nikah',
          'Mahar (Maskawin)',
          'Walimah (Resepsi)',
          'Doa-doa Pernikahan',
        ],
      },
      {
        'title': 'Pasca Nikah',
        'icon': Icons.home_filled,
        'gradient': [Colors.blue[300]!, Colors.blue[500]!],
        'subMenus': [
          'Hak dan Kewajiban Suami Istri',
          'Adab Bergaul Suami Istri',
          'Nafkah dalam Islam',
          'Mendidik Anak',
          'Mengatasi Konflik Rumah Tangga',
        ],
      },
    ];

    final batch = db.batch();

    for (var categoryData in initialCategories) {
      final categoryId = await db.insert('categories', {
        'title': categoryData['title'],
        'iconCodePoint': (categoryData['icon'] as IconData).codePoint,
        'startColor': (categoryData['gradient'] as List<Color>)[0].value,
        'endColor': (categoryData['gradient'] as List<Color>)[1].value,
      });

      for (var subMenuTitle in categoryData['subMenus'] as List<String>) {
        batch.insert('sub_menus', {
          'title': subMenuTitle,
          'categoryId': categoryId,
        });

        // Menambahkan konten placeholder untuk setiap sub-menu
        batch.insert('contents', {
          'subMenuTitle': subMenuTitle,
          'content':
              'Konten detail untuk "$subMenuTitle" akan ditampilkan di sini. '
                  'Ini adalah konten yang dimuat dari database SQLite. '
                  'Anda bisa mengisinya dengan penjelasan, dalil, dan contoh praktis yang relevan.'
        });
      }
    }

    await batch.commit(noResult: true);
  }

  Future<List<MenuCategory>> getAllCategoriesWithSubMenus() async {
    final db = await database;
    final List<Map<String, dynamic>> categoryMaps =
        await db.query('categories');
    final List<MenuCategory> categories = [];

    for (var categoryMap in categoryMaps) {
      final category = MenuCategory.fromMap(categoryMap);
      final List<Map<String, dynamic>> subMenuMaps = await db.query(
        'sub_menus',
        where: 'categoryId = ?',
        whereArgs: [category.id],
      );
      category.subMenus = subMenuMaps.map((sm) => SubMenu.fromMap(sm)).toList();
      categories.add(category);
    }

    return categories;
  }

  // Fungsi baru untuk mendapatkan konten berdasarkan judul sub-menu
  Future<Content?> getContentBySubMenuTitle(String subMenuTitle) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contents',
      where: 'subMenuTitle = ?',
      whereArgs: [subMenuTitle],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Content.fromMap(maps.first);
    }
    return null;
  }
}
