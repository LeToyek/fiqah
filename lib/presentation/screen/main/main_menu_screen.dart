import 'package:fiqah/data/menu_category_dto.dart';
import 'package:fiqah/presentation/screen/main/sub_menu_screen.dart';
import 'package:fiqah/presentation/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainMenuScreen extends ConsumerWidget {
  final List<MenuCategory> categories = [
    MenuCategory(
      title: 'Pra Nikah',
      icon: Icons.psychology,
      gradient: [Colors.pink[300]!, Colors.pink[500]!],
      subMenus: [
        'Memilih Pasangan',
        'Khitbah (Peminangan)',
        'Syarat dan Rukun Nikah',
        'Adab Sebelum Menikah',
        'Persiapan Mental dan Spiritual',
      ],
    ),
    MenuCategory(
      title: 'Nikah',
      icon: Icons.favorite,
      gradient: [Colors.green[300]!, Colors.green[500]!],
      subMenus: [
        'Ijab Kabul',
        'Saksi Nikah',
        'Mahar (Maskawin)',
        'Walimah (Resepsi)',
        'Doa-doa Pernikahan',
      ],
    ),
    MenuCategory(
      title: 'Pasca Nikah',
      icon: Icons.home_filled,
      gradient: [Colors.blue[300]!, Colors.blue[500]!],
      subMenus: [
        'Hak dan Kewajiban Suami Istri',
        'Adab Bergaul Suami Istri',
        'Nafkah dalam Islam',
        'Mendidik Anak',
        'Mengatasi Konflik Rumah Tangga',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
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
              _buildHeader(context, ref),
              Expanded(
                child: _buildMenuGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final currentTheme = ref.watch(themeModeProvider);

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 12),
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
              _buildThemeToggleButton(
                  context, ref, themeNotifier, currentTheme),
            ],
          ),
          SizedBox(height: 8),
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
          title: Text('Pilih Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context,
                ref,
                'Sistem',
                Icons.brightness_auto,
                ThemeMode.system,
              ),
              _buildThemeOption(
                context,
                ref,
                'Terang',
                Icons.light_mode,
                ThemeMode.light,
              ),
              _buildThemeOption(
                context,
                ref,
                'Gelap',
                Icons.dark_mode,
                ThemeMode.dark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    ThemeMode mode,
  ) {
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
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 2.5,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildMenuCard(context, categories[index]);
        },
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuCategory category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: category.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: category.gradient[1].withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
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
                builder: (context) => SubMenuScreen(category: category),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(24),
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
                    category.icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
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
                Icon(
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
}
