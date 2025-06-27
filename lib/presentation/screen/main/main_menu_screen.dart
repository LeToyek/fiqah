import 'package:fiqah/data/models/menu_category_model.dart';
import 'package:fiqah/data/services/database_helper.dart';
import 'package:fiqah/presentation/screen/main/sub_menu_screen.dart';
import 'package:fiqah/presentation/theme/theme_provider.dart'; // Asumsi path ini benar
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider untuk mengambil data dari database, tidak berubah.
final categoriesProvider = FutureProvider<List<MenuCategory>>((ref) async {
  return DatabaseHelper().getAllCategoriesWithSubMenus();
});

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(categoriesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        // Latar belakang gradien dari kode lama Anda
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Menggunakan header dari kode lama Anda
              _buildHeader(context, ref),
              Expanded(
                // Menggunakan .when() untuk menangani state dari FutureProvider
                child: asyncCategories.when(
                  data: (categories) => _buildMenuGrid(context, categories),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header dari kode lama Anda
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final currentTheme = ref.watch(themeModeProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Fiqih Pernikahan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              _buildThemeToggleButton(context, ref, themeNotifier, currentTheme),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih kategori untuk mempelajari fiqih pernikahan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Grid/List dari menu, diadaptasi dari kode lama Anda
  Widget _buildMenuGrid(BuildContext context, List<MenuCategory> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Diubah menjadi 1 agar terlihat seperti list
          childAspectRatio: 3.5, // Disesuaikan rasionya
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          // Menggunakan _buildMenuCard dari kode lama Anda
          return _buildMenuCard(context, categories[index]);
        },
      ),
    );
  }

  // Kartu menu dari kode lama Anda
  Widget _buildMenuCard(BuildContext context, MenuCategory category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: category.gradient, // Menggunakan warna dari DB
        ),
        boxShadow: [
          BoxShadow(
            color: category.gradient[1].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubMenuScreen(
                  // Meneruskan data yang diperlukan ke SubMenuScreen
                  categoryTitle: category.title,
                  subMenus: category.subMenus.map((sm) => sm.title).toList(),
                  gradient: category.gradient,
                  icon: category.icon, // Menambahkan icon
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    category.icon, // Menggunakan icon dari DB
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category.subMenus.length} materi tersedia',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Semua fungsi untuk theme switcher dari kode lama Anda
  Widget _buildThemeToggleButton(
    BuildContext context,
    WidgetRef ref,
    ThemeModeNotifier themeNotifier,
    ThemeMode currentTheme,
  ) {
    IconData icon;
    String tooltip;

    switch (currentTheme) {
      case ThemeMode.system:
        icon = Icons.brightness_auto;
        tooltip = 'System Theme';
        break;
      case ThemeMode.light:
        icon = Icons.light_mode;
        tooltip = 'Light Theme';
        break;
      case ThemeMode.dark:
        icon = Icons.dark_mode;
        tooltip = 'Dark Theme';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () => _showThemeDialog(context, ref),
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        tooltip: tooltip,
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(context, ref, 'Sistem', Icons.brightness_auto, ThemeMode.system),
              _buildThemeOption(context, ref, 'Terang', Icons.light_mode, ThemeMode.light),
              _buildThemeOption(context, ref, 'Gelap', Icons.dark_mode, ThemeMode.dark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(BuildContext context, WidgetRef ref, String title, IconData icon, ThemeMode mode) {
    final currentTheme = ref.watch(themeModeProvider);
    final isSelected = currentTheme == mode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : null,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
