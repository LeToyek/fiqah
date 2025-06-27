import 'package:fiqah/data/models/menu_category_model.dart';
import 'package:fiqah/data/models/sub_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern untuk memastikan hanya ada satu instance database helper.
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Getter untuk database. Jika belum ada, akan diinisialisasi.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database. Membuat file database di path yang sesuai.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fiqah_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // Method ini akan dipanggil saat DB dibuat pertama kali.
    );
  }

  // Membuat tabel-tabel yang diperlukan.
  Future<void> _onCreate(Database db, int version) async {
    // Membuat tabel untuk kategori
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        iconCodePoint INTEGER NOT NULL,
        startColor INTEGER NOT NULL,
        endColor INTEGER NOT NULL
      )
    ''');

    // Membuat tabel untuk sub-menu
    await db.execute('''
      CREATE TABLE sub_menus(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');
    
    // Panggil method untuk mengisi data awal (seeding)
    await _seedDatabase(db);
  }

  // Mengisi data awal ke dalam database.
  Future<void> _seedDatabase(Database db) async {
    final List<Map<String, dynamic>> initialCategories = [
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

    // Gunakan batch untuk efisiensi
    final batch = db.batch();

    for (var categoryData in initialCategories) {
      // Masukkan kategori dan dapatkan ID-nya
      final categoryId = await db.insert('categories', {
        'title': categoryData['title'],
        'iconCodePoint': (categoryData['icon'] as IconData).codePoint,
        'startColor': (categoryData['gradient'] as List<Color>)[0].value,
        'endColor': (categoryData['gradient'] as List<Color>)[1].value,
      });

      // Masukkan semua sub-menu yang terkait dengan kategori ini
      for (var subMenuTitle in categoryData['subMenus'] as List<String>) {
        batch.insert('sub_menus', {
          'title': subMenuTitle,
          'categoryId': categoryId,
        });
      }
    }
    
    await batch.commit(noResult: true); // Eksekusi semua operasi dalam batch
  }

  // Mengambil semua kategori beserta sub-menunya.
  Future<List<MenuCategory>> getAllCategoriesWithSubMenus() async {
    final db = await database;
    
    // Ambil semua kategori
    final List<Map<String, dynamic>> categoryMaps = await db.query('categories');
    final List<MenuCategory> categories = [];

    for (var categoryMap in categoryMaps) {
      final category = MenuCategory.fromMap(categoryMap);
      
      // Untuk setiap kategori, ambil sub-menunya
      final List<Map<String, dynamic>> subMenuMaps = await db.query(
        'sub_menus',
        where: 'categoryId = ?',
        whereArgs: [category.id],
      );
      
      // Tambahkan sub-menu ke list di dalam objek kategori
      category.subMenus = subMenuMaps.map((sm) => SubMenu.fromMap(sm)).toList();
      categories.add(category);
    }
    
    return categories;
  }
}

